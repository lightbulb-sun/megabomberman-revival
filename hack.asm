NUM_LIVES                       = $ff9543
INITIAL_X                       = $ff954a
INITIAL_Y                       = $ff954c

; all offsets relative to a4=$ffa432
OFFSET_GAME_STATE               = $02
OFFSET_CHARACTER_STATE          = $10
OFFSET_INVINCIBILITY_TIMER      = $12
OFFSET_DIRECTION                = $14
OFFSET_CHARACTER_APPEARANCE     = $15
OFFSET_X                        = $18
OFFSET_Y                        = $1a

GAME_STATE_ALIVE                = $1f7e
GAME_STATE_DEAD                 = $31d4
CHARACTER_STATE_ALIVE           = $0001
NUM_INVINCIBILITY_FRAMES        = $80
DIRECTION_SOUTH                 = $02
CHARACTER_APPEARANCE_ALIVE      = $00

    org 0
    incbin "megabomberman.md"

    org $31c2
            jmp         my_code
            nop

    org $ffa00
my_code:
            cmpi.b      #0, NUM_LIVES
            bne         .respawn
            ; replace original instruction
            move.l      #GAME_STATE_DEAD, (OFFSET_GAME_STATE, a4)
            jmp         $31ca
.respawn
            ; set state to alive
            move.l      #GAME_STATE_ALIVE, (OFFSET_GAME_STATE, a4)
            move.w      #CHARACTER_STATE_ALIVE, (OFFSET_CHARACTER_STATE, a4)
            move.b      #CHARACTER_APPEARANCE_ALIVE, (OFFSET_CHARACTER_APPEARANCE, a4)

            ; reset to starting position
            move.w      INITIAL_X, (OFFSET_X, a4)
            move.w      INITIAL_Y, (OFFSET_Y, a4)

            ; face south
            move.b      #DIRECTION_SOUTH, (OFFSET_DIRECTION, a4)

            ; activate temporary invincibility
            move.b      #NUM_INVINCIBILITY_FRAMES, (OFFSET_INVINCIBILITY_TIMER, a4)

            ; decrement life counter
            move.b      NUM_LIVES, d0
            sub.b       #$1, d0
            move.b      d0, NUM_LIVES
            rts

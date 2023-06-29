package main

import rl "vendor:raylib"

main :: proc() {
    // constants
    title :: "Circle Tosser"
    width :: 500
    height :: 500
    radius :: 40.0
    xBorder :: width - radius
    yBorder :: height - radius

    decoy :: 0.995
    speed_limit :: 10.0

    // variables
    isHeld: bool = false
    onPause: bool = false
    center: rl.Vector2 = {
        width/2,
        height/2,
    }
    speed: rl.Vector2 = {
        0.0,
        0.0,
    }
    limit :: proc(val: f32) -> f32 {
        if val > speed_limit do return speed_limit
        if val < -speed_limit do return -speed_limit

        return val
    } 

    rl.InitWindow(width,height,title)

    rl.SetTargetFPS(60)
    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(rl.KeyboardKey.SPACE) do onPause = !onPause

        if !onPause {
            // UPDATE
            if rl.CheckCollisionPointCircle(rl.GetMousePosition(),center,radius) || isHeld {
                if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
                    isHeld = true
                    speed = {0.0,0.0}
                }

                if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
                    delta := rl.GetMouseDelta()
                    if newX := center.x + delta.x; newX > radius && newX < xBorder {
                        center.x = newX
                    }
                    if newY := center.y + delta.y; newY > radius && newY < yBorder {
                        center.y = newY
                    }
                }
            }

            if isHeld && rl.IsMouseButtonReleased(rl.MouseButton.LEFT) {
                isHeld = false
                delta := rl.GetMouseDelta()
                speed.x = 0.5 * delta.x
                speed.y = 0.5 * delta.y
            }

            if !isHeld {
                // check collisions
                {
                    if center.x <= radius || center.x >= xBorder do speed.x *= -1
                    if center.y <= radius || center.y >= yBorder do speed.y *= -1
                }

                center.x += speed.x
                center.y += speed.y

                speed.x *= decoy
                speed.y *= decoy
            }
        }
        // UPDATE

        rl.BeginDrawing()
        {// DRAW
            rl.ClearBackground(rl.BLUE)
            rl.DrawCircleV(center, radius, rl.WHITE)
            if onPause do rl.DrawText("PAUSE", width/3, height/2, height/10, rl.GRAY)
        }// DRAW
        rl.EndDrawing()

    }

}
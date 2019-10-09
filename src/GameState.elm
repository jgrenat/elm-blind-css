module GameState exposing (GameState, gameStateDecoder)

import Json.Decode as Decode


type alias GameState =
    { poster : Maybe String
    }


gameStateDecoder : Decode.Decoder GameState
gameStateDecoder =
    Decode.field "posterUrl" (Decode.maybe Decode.string)
        |> Decode.map GameState

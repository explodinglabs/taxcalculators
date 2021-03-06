module Main exposing (main)

import Browser
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (usLocale)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


type alias Model =
    { income : String
    }


type Msg
    = Income String


calc : Float -> Float
calc income =
    if income >= 180001 then
        (income - 180000) * 0.45 + 51667

    else if income >= 120001 then
        (income - 120000) * 0.37 + 29467

    else if income >= 45001 then
        (income - 45000) * 0.325 + 5092

    else if income >= 18201 then
        (income - 18200) * 0.19

    else
        0.0


init : Model
init =
    Model ""


update : Msg -> Model -> Model
update msg model =
    case msg of
        Income income ->
            { model | income = String.filter (\x -> List.member x <| String.toList ".1234567890") income }


view : Model -> Html Msg
view model =
    let
        income =
            Maybe.withDefault 0 <| String.toFloat model.income

        taxPayable =
            calc income

        netAfterTax =
            income - taxPayable
    in
    node "main"
        [ class "wrapper" ]
        [ node "header"
            []
            [ h1 [] [ text "Australian Income Tax Calculator 2022" ]
            ]
        , h2 [] [ text "Taxable Income" ]
        , input [ type_ "input", attribute "inputmode" "numeric", value <| "$" ++ model.income, onInput Income, autofocus True, maxlength 14 ] []
        , h2 [] [ text "Tax Payable" ]
        , div [ class "result" ] [ text <| "$" ++ (String.replace ".00" "" <| format usLocale taxPayable) ]
        , h2 [] [ text "Net after Tax" ]
        , div [ class "result" ] [ text <| "$" ++ (String.replace ".00" "" <| format usLocale netAfterTax) ]
        ]


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }

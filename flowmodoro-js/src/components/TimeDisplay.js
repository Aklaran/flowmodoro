import React from "react";
import PropTypes from "prop-types";
import styled from "styled-components";
import { COLORS } from "../constants";

function TimeDisplay(props) {
    const minutes = ("0" + Math.floor(props.seconds / 60)).slice(-2);
    const seconds = ("0" + (props.seconds % 60)).slice(-2);
    const style = STYLES[props.variant];

    return (
        <Display style={style}>
            {minutes}:{seconds}
        </Display>
    );
}

TimeDisplay.propTypes = {
    seconds: PropTypes.number,
    variant: PropTypes.string,
};

const Display = styled.p`
    font-family: SquareSans;
    font-size: var(--font-size);
    transform: scale(0.75, 1);
    letter-spacing: 0.15rem;
    font-weight: var(--font-weight);
    color: var(--color);

    /* Optical centering because the font has trailing space in each glyph*/
    margin-right: var(--margin-right);
`;

const STYLES = {
    primary: {
        "--font-weight": 1000,
        "--font-size": 10 + "rem",
        "--margin-right": -1 + "rem",
        "--color": COLORS.burgundy,
    },
    secondary: {
        "--font-weight": 300,
        "--font-size": 5 + "rem",
        "--margin-right": -0.5 + "rem",
        "--color": COLORS.purple,
    },
};

export default TimeDisplay;

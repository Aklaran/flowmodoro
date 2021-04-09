import React from "react";
import PropTypes from "prop-types";
import styled from "styled-components";
import { COLORS } from "../constants";

function Button(props) {
    const text = props.isActive ? props.activeText : props.inactiveText;
    return <Wrapper onClick={props.onClick}>{text}</Wrapper>;
}

Button.propTypes = {
    isActive: PropTypes.bool,
    activeText: PropTypes.string,
    inactiveText: PropTypes.string,
    onClick: PropTypes.func,
};

const Wrapper = styled.button`
    background-color: transparent;
    border: 5px solid ${COLORS.lightpurple};
    color: ${COLORS.lightpurple};
    border-radius: 25%/50%;
    width: 150px;
    height: 57px;
    font-size: 2rem;
    font-family: Quicksand;
    font-weight: 400;
    margin-bottom: 15px;

    &:hover {
        color: ${COLORS.purple};
        border-color: ${COLORS.purple};
        box-shadow: 0 5px ${COLORS.transparentGray35};
    }

    &:active {
        box-shadow: 0 3px ${COLORS.transparentGray35};
        transform: translateY(2px);
    }
`;

export default Button;

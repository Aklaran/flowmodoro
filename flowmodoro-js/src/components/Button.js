import React from "react";
import PropTypes from "prop-types";
import styled from "styled-components";
import { COLORS } from "../constants";

function Button(props) {
    const ButtonType = TYPES[props.type];
    const text = props.isActive ? props.activeText : props.inactiveText;

    return (
        <ButtonType onClick={props.onClick} isVisible={props.isVisible}>
            {text}
        </ButtonType>
    );
}

Button.propTypes = {
    type: PropTypes.string,
    isActive: PropTypes.bool,
    activeText: PropTypes.string,
    inactiveText: PropTypes.string,
    onClick: PropTypes.func,
    isVisible: PropTypes.bool,
};

const ButtonWrapper = styled.button`
    background-color: transparent;
    color: ${COLORS.lightpurple};
    font-family: Quicksand;
    font-weight: 400;
    margin-bottom: 15px;
    visibility: ${(props) => !props.isVisible && "hidden"};

    &:hover {
        color: ${COLORS.purple};
        cursor: pointer;
    }
`;

const PrimaryButton = styled(ButtonWrapper)`
    border: 5px solid ${COLORS.lightpurple};
    border-radius: 25%/50%;
    width: 150px;
    height: 57px;
    font-size: 2rem;

    &:hover {
        border-color: ${COLORS.purple};
        box-shadow: 0 5px 5px ${COLORS.transparentGray35};
        text-shadow: 0 3px 3px ${COLORS.transparentGray35};
    }

    &:active {
        box-shadow: 0 3px 3px ${COLORS.transparentGray35};
        text-shadow: 0 1px 1px ${COLORS.transparentGray35};
        transform: translateY(2px);
    }
`;

const SecondaryButton = styled(ButtonWrapper)`
    font-size: 1rem;
    border: none;
    text-decoration: underline;
`;

const TYPES = {
    primary: PrimaryButton,
    secondary: SecondaryButton,
};

export default Button;

import React from "react";
import PropTypes from "prop-types";
import styled from "styled-components";
import { COLORS } from "../constants";

import XMark from "../assets/images/x-mark.svg";

function AboutModal({ onCloseClicked }) {
    return (
        <Wrapper>
            <CloseButton
                src={XMark}
                alt="Close"
                onClick={() => onCloseClicked(false)}
            />
            <h1>What is Flowmodoro?</h1>
            <p>
                Flowmodoro is the only Pomodoro timer that understands your life
                is hectic. It works just like a regular Pomodoro timer, but
                allows you to be flexible on the length of your focus sessions
                *without* punishing you.
            </p>
            <ol>
                <li>Click "Focus" to start the focus timer.</li>
                <li>
                    Every 5 seconds of focus, Flowmodoro grants you 1 second of
                    focus time. That amounts to 5 minutes of break after 25
                    minutes of focus.
                </li>
                <li>
                    When you click "Break", the focus timer pauses, and the
                    break timer starts counting down with whatever amount you
                    have accumulated.
                </li>
                <li>
                    As long the break timer stays above 0, you can click "Focus"
                    to resume the focus timer where it left off.
                </li>
                <li>
                    Once you have focused for 25 minutes, you have completed a
                    focus session (we call it a Pom)!
                </li>
                <li>
                    After completing 4 focus sessions, you've completed a
                    Clover! For every Clover completed, Flowmodoro grants you an
                    instant 15 minutes of break.
                </li>
                <li>
                    Keep flowing, do what you need to do, and kick back once
                    you're done :)
                </li>
            </ol>
        </Wrapper>
    );
}

AboutModal.propTypes = {
    onCloseClicked: PropTypes.func,
};

export default AboutModal;

const Wrapper = styled.div`
    background-color: white;
    position: absolute;
    height: 700px;
    width: 700px;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    margin: auto;
    box-shadow: 0px 5px 5px ${COLORS.transparentGray15};
    border-radius: 25px;
    padding: 40px;

    font-family: Quicksand;

    & > h1 {
        font-size: 2rem;
        font-weight: 0;
        margin-bottom: 2rem;
    }

    & > p,
    li {
        margin-bottom: 1rem;
    }

    & > ol {
        list-style-type: decimal;
        list-style-position: outside;
        margin-left: 1rem;
    }
`;

const CloseButton = styled.img`
    &:hover {
        cursor: pointer;
    }

    position: absolute;
    top: 15px;
    right: 15px;
`;

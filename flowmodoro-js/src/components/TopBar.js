import React from "react";
import PropTypes from "prop-types";
import styled from "styled-components";

import Wolf from "../assets/images/wolf.svg";
import { COLORS } from "../constants";

function TopBar({ onFaqClick }) {
    return (
        <Wrapper>
            <a
                href="https://aklarans.voyage"
                target="_blank"
                rel="noopener noreferrer"
            >
                <img src={Wolf} alt="Aklaran" height="50px" width="50px" />
            </a>
            <div>
                <FaqLink onClick={() => onFaqClick(true)}>
                    What is this?
                </FaqLink>
            </div>
        </Wrapper>
    );
}

TopBar.propTypes = {
    onFaqClick: PropTypes.func,
};

const Wrapper = styled.div`
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    padding: 25px;
`;

const FaqLink = styled.a`
    font-family: Quicksand;
    color: ${COLORS.lightpurple};

    &:hover {
        color: ${COLORS.purple};
        cursor: pointer;
    }
`;

export default TopBar;

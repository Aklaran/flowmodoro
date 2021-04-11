import React, { useState } from "react";
import styled from "styled-components";

import Timer from "./Timer";
import { COLORS } from "../constants";
import backgroundImage from "../assets/images/the_glacier_above.jpg";
import TopBar from "./TopBar";
import AboutModal from "./AboutModal";

export default function App() {
    const [isAboutModalOpen, setIsAboutModalOpen] = useState(false);

    return (
        <Wrapper>
            <TopBar onFaqClick={setIsAboutModalOpen} />
            <Timer />
            <Background />
            <BackgroundOverlay />
            {isAboutModalOpen && (
                <AboutModal onCloseClicked={setIsAboutModalOpen} />
            )}
        </Wrapper>
    );
}

const Wrapper = styled.div`
    height: 100%;
`;

const Background = styled.div`
    position: absolute;
    background-image: url(${backgroundImage});
    background-size: cover;
    background-position: center center;
    height: 100%;
    width: 100%;
    top: 0;
    left: 0;
    z-index: -10;
`;

const BackgroundOverlay = styled.div`
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    background-color: rgba(255, 255, 255, 0.9);
    z-index: -9;
`;

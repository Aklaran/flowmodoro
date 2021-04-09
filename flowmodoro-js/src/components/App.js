import React from "react";
import styled from "styled-components";

import Timer from "./Timer";
import { COLORS } from "../constants";

export default function App() {
    return (
        <Wrapper>
            <Timer />
        </Wrapper>
    );
}

const Wrapper = styled.div`
    height: 100%;
    background-color: ${COLORS.gray300};
`;

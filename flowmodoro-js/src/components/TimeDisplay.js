import React from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components';

function TimeDisplay(props) {
    return (
        <Display>
            {props.seconds}
        </Display>
    )
}

TimeDisplay.propTypes = {
    seconds: PropTypes.number
};

const Display = styled.p`
  
`;

export default TimeDisplay


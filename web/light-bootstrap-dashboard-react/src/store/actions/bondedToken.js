import * as actionTypes from './actionTypes';

export const setSupply = (totalSupply) => {
    return {
        type: actionTypes.SET_SUPPLY,
        totalSupply: totalSupply
    };
};

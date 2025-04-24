'use strict';

exports.test = async (event) => {
    const response = event.Records[0].cf.response;
    return response;
};

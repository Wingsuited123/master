'use strict';

exports.handler = async (event) => {
    const response = event.Records[0].cf.response;
    return response;
};

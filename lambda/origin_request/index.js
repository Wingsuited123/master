'use strict';

exports.func = async (event) => {
    const request = event.Records[0].cf.request;
    return request;
};

'use strict';

exports.handler = async (event) => {
    const request = event.Records[0].cf.request;
    const uri = request.uri;

    if (uri === '/check') {
        return {
            status: '302',
            statusDescription: 'Found',
            headers: {
                location: [
                    {
                        key: 'Location',
                        value: '/target',
                    },
                ],
            },
        };
    }

    // Continue with the original request if no match
    return request;
};

diag('Регионы:');

run_swat_module(
    GET => '/areas',
    {   
        check_sub => sub {
            [
            '200 OK',
            'valid json',
            ]
        },
    }
);

set_response('done');

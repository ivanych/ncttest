diag('GET /areas');

run_swat_module(
    GET => '/areas',
    {   
        check_sub => sub {
            [
                '200 OK',
                'valid json',
                'country[id=113].name=Россия',
                'country[id=113].areas[id=2].name=Санкт-Петербург',
            ]
        },
    }
);

set_response('done');

diag('GET /employers');

run_swat_module(
    GET => '/employers',
    {   
        text      => 'Новые Облачные Технологии',
        area      => '113',
        
        check_sub => sub {
            [
                '200 OK',
                'valid json',
                'items.name=Новые Облачные Технологии',
            ]
        },
    }
);

set_response('done');

diag('GET /vacancies');

run_swat_module(
    GET => '/vacancies',
    {   
        text        => 'QA Automation Engineer',
        area        => '2',
        employer_id => '213397',
        
        check_sub => sub {
            [
                '200 OK',
                'valid json',
                'regexp: items\.name=.*?QA Automation Engineer',
            ]
        },
    }
);

set_response('done');

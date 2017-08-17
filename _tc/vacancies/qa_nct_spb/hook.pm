diag('GET /areas');

# Идентификатор города
our $spb_id;
# Идентификатор страны
our $russia_id;
# Идентификатор работодателя
our $employer_id;

my $response_processor_areas = sub {
    use JSON;
    use JSON::Path;
    use Encode;
    use DDP;

    $JSON::Path::Safe = 0;

    my $headers = shift;
    my $body    = shift;

    my $response = '';

    # 200 OK
    $response .= $headers;
    
    my $json;
    eval { $json = decode_json($body); };
    
    if ( !$@ ) {

        # Валидный JSON
        $response .= "valid json\n";

        # id города по названию
        {
            my $country = decode_utf8 ("Россия");
            my $area    = decode_utf8 ("Санкт-Петербург");
            # сравнение area по регулярке, точное совпадение eq как-то странно работает
            my $jpath = JSON::Path->new('$[?($_->{name} eq ' . $country . ')].areas[?($_->{name} =~ /' . $area . '/)].[id,parent_id]');
            my ($val, $parent) = $jpath->values($json);

            utf8::encode $val;
            utf8::encode $parent;

            diag( "Ответ содержит значение: страна.areas.id = " . np $val);
            diag( "Ответ содержит значение: страна.areas.parent_id = " . np $parent);

            $response .= "страна[name=Россия].areas[name=Санкт-Петербург].id=$val\n";
            $response .= "страна[name=Россия].areas[name=Санкт-Петербург].parent_id=$parent\n";
        }

    }

    #diag $response;
    return $response;
};

run_swat_module(
    GET => '/areas',
    {   
        response_processor => $response_processor_areas,
        check_sub => sub {
            [
                '200 OK',
                'valid json',
                'regexp: страна\[name=Россия\].areas\[name=Санкт-Петербург\].id=(\d+)',
                'code: our $spb_id = capture()->[0]',
                'regexp: страна\[name=Россия\].areas\[name=Санкт-Петербург\].parent_id=(\d+)',,
                'code: our $russia_id = capture()->[0]',
            ]
        },
    }
);



diag('GET /employers');

my $response_processor = sub {
    use JSON;
    use JSON::Path;
    use Encode;
    use DDP;

    $JSON::Path::Safe = 0;

    my $headers = shift;
    my $body    = shift;

    my $response = '';

    # 200 OK
    $response .= $headers;
    
    my $json;
    eval { $json = decode_json($body); };
    
    if ( !$@ ) {

        # Валидный JSON
        $response .= "valid json\n";
        
        # Работодатель
        {
            my $jpath = JSON::Path->new('$.items.[0].id');
            my ($val) = $jpath->values($json);

            utf8::encode $val;
            
            diag( 'Ответ содержит значения: items.id = ' . np $val);

            $response .= "items.id=$val\n";
        }

    }

    #diag $response;
    return $response;
};

run_swat_module(
    GET => '/employers',
    {   
        text      => 'Новые Облачные Технологии',
        area      => $russia_id,

        response_processor => $response_processor,
        check_sub => sub {
            [
                '200 OK',
                'valid json',
                'regexp: items\.id=(\d+)',
                'code: our $employer_id = capture()->[0]',
            ]
        },
    }
);








diag('GET /vacancies');

my $response_processor = sub {
    use JSON;
    use JSON::Path;
    use Encode;
    use DDP;

    $JSON::Path::Safe = 0;

    my $headers = shift;
    my $body    = shift;

    my $response = '';

    # 200 OK
    $response .= $headers;
    
    my $json;
    eval { $json = decode_json($body); };
    
    if ( !$@ ) {

        # Валидный JSON
        $response .= "valid json\n";

        # Вакансии
        {
            my $jpath = JSON::Path->new('$.items.*.name');
            my @val = map {encode_utf8 $_} $jpath->values($json);

            diag( 'Ответ содержит значения: @val = ' . np @val);

            for my $val (@val) {
                $response .= "items.name=$val\n";
            }
        }

    }

    #diag $response;
    return $response;
};

run_swat_module(
    GET => '/vacancies',
    {   
        text        => 'QA Automation Engineer',
        area        => $spb_id,
        employer_id => '213397',
        
        response_processor => $response_processor,
        check_sub => sub {
            [
                '200 OK',
                'valid json',
                'regexp: items\.name=.*?QA Automation Engineer',
            ]
        },
    }
);

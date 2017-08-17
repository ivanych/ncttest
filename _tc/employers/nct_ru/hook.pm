diag('GET /areas');

# Идентификатор страны
our $russia_id;

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

        # id cтраны по названию
        {
            my $name = decode_utf8 ("Россия");
            my $jpath = JSON::Path->new('$[?($_->{name} eq ' . $name .')].id');
            my ($val) = $jpath->values($json);

            utf8::encode $val;

            diag( "Ответ содержит значение: страна.id = " . np $val);

            $response .= "страна[name=Россия].id=$val\n";
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
                'regexp: страна\[name=Россия\].id=(\d+)',
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
    GET => '/employers',
    {   
        text      => 'Новые Облачные Технологии',
        area      => $russia_id,

        response_processor => $response_processor,
        check_sub => sub {
            [
                '200 OK',
                'valid json',
                'items.name=Новые Облачные Технологии',
            ]
        },
    }
);

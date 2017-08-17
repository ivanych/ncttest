diag('GET /areas');

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

        # Страна по id
        {
            my $jpath = JSON::Path->new('$[?($_->{id} == 113)].name');
            my ($val) = $jpath->values($json);

            utf8::encode $val;

            diag( "Ответ содержит значение: cтрана.name = " . np $val);

            $response .= "страна[id=113].name=$val\n";
        }

        # Регион по id
        {
            my $jpath = JSON::Path->new('$[?($_->{id} == 113)].areas[?($_->{id} == 2)].name');
            my ($val) = $jpath->values($json);

            utf8::encode $val;

            diag( "Ответ содержит значение: страна.areas.name = " . np $val);

            $response .= "страна[id=113].areas[id=2].name=$val\n";
        }
    }

    #diag $response;
    return $response;
};

run_swat_module(
    GET => '/areas',
    {   
        
        response_processor => $response_processor,
        check_sub => sub {
            [
                '200 OK',
                'valid json',
                'страна[id=113].name=Россия',
                'страна[id=113].areas[id=2].name=Санкт-Петербург',
            ]
        },
    }
);

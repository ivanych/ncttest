set_response_processor(
    sub {
        use JSON;
        use JSON::Path;
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

            # Страна
            {
                my $jpath = JSON::Path->new('$[?($_->{id} == 113)].name');
                my ($val) = $jpath->values($json);

                utf8::encode $val;

                diag( "Ответ содержит значение: cтрана = " . np $val);

                $response .= "country[id=113].name=$val\n";
            }

            # Регион
            {
                my $jpath = JSON::Path->new('$[?($_->{id} == 113)].areas[?($_->{id} == 2)].name');
                my ($val) = $jpath->values($json);

                utf8::encode $val;

                diag( "Ответ содержит значение: регион = " . np $val);

                $response .= "country[id=113].areas[id=2].name=$val\n";
            }

        }

        #diag $response;
        return $response;
    }
);

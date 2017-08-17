set_response_processor(
    sub {
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
    }
);

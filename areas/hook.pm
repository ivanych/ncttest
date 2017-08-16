diag('Процессор:');

set_response_processor( sub {
    use JSON;
  
    my $headers   = shift;
    my $body      = shift;

    eval {
        my $hash = decode_json($body);
    };

    
    if (!$@) {
        $headers .
        "valid json\n";
    }
    else {
        'error decode_json';
    }

});

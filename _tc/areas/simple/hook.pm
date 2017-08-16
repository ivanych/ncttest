use JSON;

diag('Регионы:');

set_response_processor( sub {

  # processor function
  my $headers   = shift;
  my $body      = shift;
  use JSON;
  eval {
   my $hash = decode_json($body);
  };

  return  $@ ?  $@  : "valid json";

});

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

#set_response('done');

diag('Регионы:');

set_response_processor( sub {

  my $headers   = shift; # original response, http headers, String
  my $body      = shift; # original response, body, String

  # processor function
  my $headers   = shift;
  my $body      = shift;
  use JSON;
  eval {
   $hash = decode_json($body);
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

use JSON;

#set_response('done');

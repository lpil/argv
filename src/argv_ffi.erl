-module(argv_ffi).

-export([load/0]).

load() ->
    Runtime = create_path(stringarg(bindir), stringarg(progname), os:type()),
    PlainArguments = lists:map(
        fun(Arg) -> unicode:characters_to_binary(Arg, utf8) end, init:get_plain_arguments()
    ),
    {Program, Arguments} = case init:get_argument(escript) of
        % We're in an escript, so the first argument is the executable name
        {ok, _} ->
            [P | Rest] = PlainArguments,
            {P, Rest};

        % We're not in a escript. Assume the cwd is the project root.
        _ ->
            {ok, Cwd} = file:get_cwd(),
            {unicode:characters_to_binary(Cwd, utf8), PlainArguments}
    end,
    {Runtime, Program, Arguments}.

stringarg(Name) ->
    case init:get_argument(Name) of
        {ok, [[Value]]} -> unicode:characters_to_binary(Value);
        _ -> <<>>
    end.

create_path(Bindir, Progname, {unix, _}) ->
    <<Bindir/binary, "/", Progname/binary>>;
create_path(Bindir, Progname, {win32, _}) ->
    <<Bindir/binary, "\\", Progname/binary>>.

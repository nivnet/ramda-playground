argv = require '../../src/argv'

make-argv = -> [,,] ++ it.split(' ')
parse = make-argv >> argv.parse

describe 'argv.parse' (,) ->
    describe '-p, --pretty' (,) ->
        it 'is an alias for --output-type pretty' ->
            parse '-p' .output-type `eq` \pretty

        it 'overrides -r' ->
            parse '-p -r' .output-type `eq` \pretty

    describe '-r, --raw-input' (,) ->
        it 'is an alias for --input-type raw' ->
            args = parse '-r'
            args.input-type  `eq` \raw

    describe '-R, --raw-output' (,) ->
        it 'is an alias for --output-type raw' ->
            args = parse '-R'
            args.output-type `eq` \raw

    describe '-o, --output-type' (,) ->
        it 'defaults to json' ->
            args = parse 'identity'
            args.output-type `eq` \json

        it 'throws an error with bad value' ->
            assert.throws (-> parse '-o lol'),
                'Output type should be one of: json, pretty, raw, csv, tsv'

    describe '-i, --input-type' (,) ->
        it 'defaults to json' ->
            args = parse 'identity'
            args.input-type `eq` \json

        it 'throws an error with bad value' ->
            assert.throws (-> parse '-i lol'),
                'Input type should be one of: json, raw, csv, tsv'

    describe '-vv' (,) ->
        it 'is parsed as very-verbose' ->
            args = parse '-vv'
            args.very-verbose `eq` true

    describe '-n, --no-stdin' (,) ->
        it 'sets stdin to false with -n' ->
            parse '-n' .stdin `eq` false

        it 'sets stdin to false with --no-stdin' ->
            parse '--no-stdin' .stdin `eq` false

        it 'sets stdin to true with --stdin' ->
            parse '--stdin' .stdin `eq` true

        it 'is boolean' ->
            parse '-n identity' .stdin `eq` false
            parse '--no-stdin identity' .stdin `eq` false

    describe '--import', (,) ->
        it 'parses simple import' ->
            parse '--import treis' .import `deep-eq` [
                { alias: undefined, package-spec: 'treis' }
            ]

        it 'parses multiple imports' ->
            parse '--import treis --import taim' .import `deep-eq` [
                { alias: undefined, package-spec: 'treis' }
                { alias: undefined, package-spec: 'taim' }
            ]

        it 'parses alias' ->
            parse '--import ramda:R' .import `deep-eq` [
                { alias: 'R', package-spec: 'ramda' }
            ]

    describe '-H, --[no-]headers', (,) ->
        it 'defaults to true' ->
            parse '' .headers `eq` true

        it 'sets `headers` to false' ->
            parse '--no-headers' .headers `eq` false

        it 'sets `headers` to true' ->
            parse '--headers' .headers `eq` true

    describe '-I, --interactive', (,) ->
        it 'defaults to true' ->
            parse '' .interactive `eq` false

        it 'sets `interactive` to true' ->
            parse '--interactive' .interactive `eq` true

    it 'wraps function expressions in parentheses' ->
         args = argv.parse [,, 'identity', '-> it']
         args._.1 `eq` '(-> it)'

    it 'reads ".0" as string' ->
         args = argv.parse [,, '.0', '.foo']
         args._.0 `eq` '(.0)'

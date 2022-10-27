def make_tests(tests, **kwargs):

    native.test_suite(
        name  = "all_tests",
        tests = [t + "_test" for t in tests]
    )

    for t in tests:

        native.sh_test(
            name = t + "_test",
            srcs = ["test_runner.sh"],
            args = [
                t,
                "$(rootpath :{}.exe)".format(t),
                "$(rootpath //test/e2e:strip_randomness.exe)",
                "$(rootpath :{}.expected)".format(t)
            ],
            data = [
                ":{}.exe".format(t),
                "//test/e2e:strip_randomness.exe",
                ":{}.expected".format(t)
            ]
        )

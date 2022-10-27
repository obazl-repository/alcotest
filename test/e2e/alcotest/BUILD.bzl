def make_tests(tests, **kwargs):
    # test: dictionary: test name => exe args

    native.test_suite(
        name  = "all_tests",
        tests = [t + "_test" for t in tests.keys()]
    )

    for (t, args) in tests.items():

        native.sh_test(
            name = t + ".actual_test",
            srcs = ["//test/e2e/alcotest:gen_actuals.sh"],
            args = [
                t,
                "$(rootpath :{}.exe)".format(t),
                args
                # "$(rootpath //test/e2e:strip_randomness.exe)",
                # "$(rootpath :{}.expected)".format(t)
            ],
            data = [
                ":{}.exe".format(t),
                # "//test/e2e:strip_randomness.exe",
                # ":{}.expected".format(t)
            ]
        )

        native.sh_test(
            name = t + "_test",
            srcs = ["//test/e2e/alcotest:test_runner.sh"],
            args = [
                t,
                "$(rootpath :{}.exe)".format(t),
                "$(rootpath //test/e2e:strip_randomness.exe)",
                "$(rootpath :{}.expected)".format(t),
                args
            ],
            # env = {"ALCOTEST_COLOR": "auto"},
            data = [
                ":{}.exe".format(t),
                "//test/e2e:strip_randomness.exe",
                ":{}.expected".format(t)
            ]
        )


module tb;

typedef struct {
    string test_name;
    int test_length;
    logic [31:0] test_contents[$];
    logic [31:0] expected_result;
} test_t;

test_t tests[$] = '{
    test_t'{
        test_name: "test 1",
        test_length: 1,
        test_contents: '{ 1 },
        expected_result: 1
    }, test_t'{
        test_name: "test 2",
        test_length: 2,
        test_contents: '{ 1, 2 },
        expected_result: 2
    }, test_t'{
        test_name: "test 3",
        test_length: 3,
        test_contents: '{ 1, 2, 3 },
        expected_result: 3
    }
};

initial begin
    foreach (tests[i]) begin
        logic [31:0] test_contents[$] = tests[i].test_contents;
        test_contents.sort;
        assert (test_contents[tests[i].test_length-1] == tests[i].expected_result);
    end
    $finish;
end

endmodule

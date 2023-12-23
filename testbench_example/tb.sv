/*
 * File: testbench_example/tb.sv
 * Author: Ethan Sifferman
 * Description: Example of using unpacked structs for verification
 */

module tb;

typedef struct {
    string test_name;
    int test_length;
    logic [31:0] test_contents[$];
    logic [31:0] expected_maximum;
} test_t;

test_t tests[$] = '{
    test_t'{
        test_name: "test 1",
        test_length: 1,
        test_contents: '{ 1 },
        expected_maximum: 1
    }, test_t'{
        test_name: "test 2",
        test_length: 2,
        test_contents: '{ 1, 2 },
        expected_maximum: 2
    }, test_t'{
        test_name: "test 3",
        test_length: 3,
        test_contents: '{ 1, 2, 3 },
        expected_maximum: 3
    }
};

initial begin
    foreach (tests[i]) begin
        logic [31:0] test_contents[$] = tests[i].test_contents;
        test_contents.sort;
        assert (test_contents[tests[i].test_length-1] == tests[i].expected_maximum);
    end
    $finish;
end

endmodule

// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
`define PULP_ASIC
module cluster_clock_gating
(
    input  logic clk_i,
    input  logic en_i,
    input  logic test_en_i,
    output logic clk_o
  );

reg coverage_flop ;
//synopsys keep_signal_name "coverage_flop"

`ifdef PULP_FPGA_EMUL
  // no clock gates in FPGA flow
  assign clk_o = clk_i;
`elsif PULP_ASIC
  SAEDRVT14_CKGTPLT_V5_4( .Q(clk_o), .CK(clk_i), .EN(en_i), .SE(test_en_i));

always @(posedge clk_i)
begin
	coverage_flop <= en_i ;
end
`else
  logic clk_en;

  always_latchver
  begin
     if (clk_i == 1'b0)
       clk_en <= en_i | test_en_i;
  end

  assign clk_o = clk_i & clk_en;
`endif

endmodule // cluster_clock_gating

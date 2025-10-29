#include "Vsinegen.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env)
{
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vsinegen *top = new Vsinegen;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("sinegen.vcd");

    // init Vbuddy
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("Lab 2: SigGen");

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 0;
    top->en = 1;
    top->incr = vbdValue();
    // top->incr = 16;

    // run simulation for many clock cycles
    for (i = 0; i < 1000000; i++)
    {
        top->incr = vbdValue();
        // dump variables into VCD file and toggle clock
        for (clk = 0; clk < 2; clk++)
        {
            tfp->dump(2 * i + clk);
            top->clk = !top->clk;
            top->eval();
        }

        // ++++ Send sine wave value to Vbuddy
        vbdPlot(int(top->dout1), 0, 255); // Plot the sine output
        vbdPlot(int(top->dout2), 0, 255); // plot second sine wave

        // ---- end of Vbuddy output section

        // change input stimuli
        top->rst = (i < 2);
        top->en = 1; // Keep enabled, or use vbdFlag() if you want control
        // top->incr = vbdValue(); // Optional: control frequency with rotary encoder

        if ((Verilated::gotFinish()) || (vbdGetkey() == 'q'))
            exit(0);
    }

    vbdClose(); // ++++
    tfp->close();
    exit(0);
}
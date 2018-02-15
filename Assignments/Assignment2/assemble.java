/*Brayden Fidler (bfidler)
  CPSC 2310 Section 1
  Assignment 2
  Feb 15, 2018

  Description: This program opens a jvm code file from the command line and 
  creates a file called executable to write the corresponding opcodes and 
  operands. It uses a 2 pass structure and groups commands by similar
  strucutures in switcht statements. There is also a hashtable for both the
  jvm opcodes and the labels accumulated in the file
*/
import java.io.*;
import java.util.*;


public class assemble {

    public static void main(String[] args) {

        Scanner pass1 = null;
        Scanner pass2 = null;
        PrintWriter execute = null;
        File assemblyCode;
        int locationCt;
        Hashtable<String, Integer> symbolTable = new Hashtable<>();
        Hashtable<String, Integer> jvmTable = new Hashtable<>();
        boolean error, done;


        //loading jvmTable with opcodes for different operations
        jvmTable.put("iconst_m1", 2);
        jvmTable.put("iconst_0", 3);
        jvmTable.put("iconst_1", 4);
        jvmTable.put("iconst_2", 5);
        jvmTable.put("iconst_3", 6);
        jvmTable.put("iconst_4", 7);
        jvmTable.put("iconst_5", 8);
        jvmTable.put("bipush", 16);
        jvmTable.put("iload_0", 26);
        jvmTable.put("iload_1", 27);
        jvmTable.put("iload_2", 28);
        jvmTable.put("iload_3", 29);
        jvmTable.put("iload", 21);
        jvmTable.put("istore_0", 59);
        jvmTable.put("istore_1", 60);
        jvmTable.put("istore_2", 61);
        jvmTable.put("istore_3", 62);
        jvmTable.put("istore", 54);
        jvmTable.put("pop", 87);
        jvmTable.put("swap", 95);
        jvmTable.put("dup", 89);
        jvmTable.put("iadd", 96);
        jvmTable.put("isub", 100);
        jvmTable.put("imul", 104);
        jvmTable.put("idiv", 108);
        jvmTable.put("irem", 112);
        jvmTable.put("ineg", 116);
        jvmTable.put("iinc", 132);
        jvmTable.put("ifeq", 153);
        jvmTable.put("ifge", 156);
        jvmTable.put("ifgt", 157);
        jvmTable.put("ifle", 158);
        jvmTable.put("iflt", 155);
        jvmTable.put("ifne", 154);
        jvmTable.put("goto", 167);
        jvmTable.put("invokevirtual", 182);
        jvmTable.put("return", 177);


        //Opening input file by means of a scanner
        if (args.length == 1) {

            assemblyCode = new File(args[0]);

            //Creating scanners to read the file
            try {
                pass1 = new Scanner(assemblyCode);
                pass2 = new Scanner(assemblyCode);
            }
            //Catching exceptions opening file
            catch (FileNotFoundException e) {
                System.out.println("Error, file not found.");
                System.exit(0);
            }
        }
        //error checking if 0 or too many arguments
        else {
            System.out.println("Error, file not on command line.");
            System.exit(0);
        }


        //Pass 1
        locationCt = 0;
        done = false;
        error = false;
        //setting this so i can read char by char
        pass1.useDelimiter("");

        while (!error && !done) {

            String nextCommand = "";

            //skipping whitespace
            while (pass1.hasNext("\\s+"))
                pass1.next();

            //reading potential command until opening (
            while (!pass1.hasNext("\\(") && !pass1.hasNext("\\s+") &&
                pass1.hasNext())
                nextCommand = nextCommand + pass1.next();
            
            //The long list of commands to check
            switch (nextCommand) {
                case "comment":
                    //skipping opening (
                    if (pass1.hasNext("\\("))
                        pass1.next();

                    //skipping whitespace
                    while (pass1.hasNext("\\s+"))
                        pass1.next();

                    //checking for open comment
                    String open = pass1.next();
                    if (!open.equals("`"))
                        error = true;
                    else
                        //skipping through comment until close
                        while (pass1.hasNext() && !pass1.hasNext("\'"))
                            pass1.next();

                    if (error)
                        System.out.println("Error, comment not closed.");
                    else
                        //skipping over closing '
                        if (pass1.hasNext("\'"))
                            pass1.next();

                    //skipping whitespace
                    while (pass1.hasNext("\\s+"))
                        pass1.next();


                    //skipping over closing )
                    if (pass1.hasNext("\\)"))
                        pass1.next();

                    break;
                case "iconst_m1":
                case "iconst_0":
                case "iconst_1":
                case "iconst_2":
                case "iconst_3":
                case "iconst_4":
                case "iconst_5":
                case "iload_0":
                case "iload_1":
                case "iload_2":
                case "iload_3":
                case "istore_0":
                case "istore_1":
                case "istore_2":
                case "istore_3":
                case "pop":
                case "swap":
                case "dup":
                case "iadd":
                case "imul":
                case "idiv":
                case "irem":
                case "ineg":
                case "isub":
                    //for these commands simply increment by one
                    locationCt++;
                    break;
                case "label":
                    //skipping opening (
                    if (pass1.hasNext("\\("))
                        pass1.next();

                    //skipping whitespace
                    while (pass1.hasNext("\\s+"))
                        pass1.next();

                    String newLabel = "";

                    //reading the label
                    while (pass1.hasNext() && !pass1.hasNext("\\s+") &&
                      !pass1.hasNext("\\)"))
                        newLabel = newLabel + pass1.next();

                    //checking for duplicate label
                    if (symbolTable.containsKey(newLabel))
                        error = true;
                    //adding to symbol table
                    else
                        symbolTable.put(newLabel, locationCt);

                    if (error)
                        System.out.println("Error, label used twice.");
                    else
                        //skipping whitespace
                        while (pass1.hasNext("\\s+"))
                            pass1.next();

                    //skipping over closing )
                    if (pass1.hasNext("\\)"))
                        pass1.next();

                    break;
                case "bipush":
                case "iload":
                case "istore":
                case "ifeq":
                case "ifge":
                case "ifgt":
                case "ifle":
                case "iflt":
                case "ifne":
                case "goto":
                case "invokevirtual":
                    locationCt += 2;

                    //skipping over the argument
                    while (pass1.hasNext() && !pass1.hasNext("\\)"))
                        pass1.next();

                    //skipping closing )
                    if (pass1.hasNext("\\)"))
                        pass1.next();

                    break;
                case "iinc":
                    locationCt += 3;

                    //skipping over both arguments
                    while (pass1.hasNext() && !pass1.hasNext("\\)"))
                        pass1.next();

                    //skipping closing )
                    if (pass1.hasNext("\\)"))
                        pass1.next();

                    break;
                case "return":
                    done = true;
                    break;
                default:
                    error = true;
                    System.out.println("Error, unknown opcode mnemonics: " +
                            nextCommand);
            }
        }


        if(error) {
            System.out.println("Unable to complete pass 1.");
            System.exit(0);
        }

        //Creating executable
        try {
            FileWriter writer = new FileWriter("executable");
            execute = new PrintWriter(writer);
        }
        catch (IOException e){
            System.out.println("Error creating executable.");
            System.exit(0);
        }


        //Pass 2
        locationCt = 0;
        done = false;
        error = false;
        pass2.useDelimiter("");
        
        while (!error && !done) {

            String nextCommand = "";

            //skipping whitespace
            while (pass2.hasNext("\\s+"))
                pass2.next();

            //reading potential command until opening (
            while (!pass2.hasNext("\\(") && !pass2.hasNext("\\s+") &&
                    pass2.hasNext())
                nextCommand = nextCommand + pass2.next();
            
            //The long list of commands to check
            switch (nextCommand) {
                case "comment":
                    //skipping opening (
                    if (pass2.hasNext("\\("))
                        pass2.next();

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();

                    //checking for open comment
                    String open = pass2.next();
                    if (!open.equals("`"))
                        error = true;
                    else
                        //skipping through comment until close
                        while (pass2.hasNext() && !pass2.hasNext("\'"))
                            pass2.next();

                    if (error)
                        System.out.println("Error, comment not closed.");
                    else
                        //skipping over closing '
                        if (pass2.hasNext("\'"))
                            pass2.next();

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();


                    //skipping over closing )
                    if (pass2.hasNext("\\)"))
                        pass2.next();

                    break;
                case "iconst_m1":
                case "iconst_0":
                case "iconst_1":
                case "iconst_2":
                case "iconst_3":
                case "iconst_4":
                case "iconst_5":
                case "iload_0":
                case "iload_1":
                case "iload_2":
                case "iload_3":
                case "istore_0":
                case "istore_1":
                case "istore_2":
                case "istore_3":
                case "pop":
                case "swap":
                case "dup":
                case "iadd":
                case "imul":
                case "idiv":
                case "irem":
                case "ineg":
                case "isub":
                    //looking up opcode
                    int opCode1 = jvmTable.get(nextCommand);

                    //printing opcode and incrementing
                    execute.println(locationCt++ + ": " + opCode1);

                    break;
                case "label":
                    //don't really worry about labels on second pass
                    //skipping over the argument
                    while (pass2.hasNext() && !pass2.hasNext("\\)"))
                        pass2.next();

                    //skipping closing )
                    if (pass2.hasNext("\\)"))
                        pass2.next();

                    break;
                case "bipush":
                case "iload":
                case "istore":
                case "invokevirtual":
                    //skipping opening parenthesis
                    if (pass2.hasNext("\\("))
                        pass2.next();

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();

                    //looking up opcode
                    int opCode2 = jvmTable.get(nextCommand);

                    String operand2 = "";

                    //reading operand
                    while (pass2.hasNext() && !pass2.hasNext("\\s+") &&
                            !pass2.hasNext("\\)")) {
                        operand2 = operand2 + pass2.next();
                    }

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();

                    //skipping close parentheses
                    if(pass2.hasNext("\\)"))
                        pass2.next();

                    //printing opcode and operand
                    execute.println(locationCt + ": " + opCode2 + " " +
                        operand2);

                    locationCt+=2;

                    break;
                case "ifeq":
                case "ifge":
                case "ifgt":
                case "ifle":
                case "iflt":
                case "ifne":
                case "goto":
                    //skipping opening (
                    if (pass2.hasNext("\\("))
                        pass2.next();

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();

                    //looking up opcode
                    int opCode3 = jvmTable.get(nextCommand);

                    String label = "";

                    //reading the label
                    while (pass2.hasNext() && !pass2.hasNext("\\s+")
                            && !pass2.hasNext("\\)"))
                        label = label + pass2.next();

                    Integer operand3 = symbolTable.get(label);
                    
                    //checking that label was in symbol table
                    if(operand3 == null) {
                        System.out.println("Label not found.");
                        System.exit(0);
                    }
                    //printing opcode and operands
                    else {
                        execute.println(locationCt + ": " + opCode3 + " " +
                            operand3);
                    }

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();

                    //skipping closing )
                    if(pass2.hasNext("\\)"))
                        pass2.next();

                    locationCt+=2;

                    break;
                case "iinc":
                    //skipping opening (
                    if (pass2.hasNext("\\("))
                        pass2.next();

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();

                    //looking up opCode
                    int opCode4 = jvmTable.get(nextCommand);

                    String arg1 = "";

                    //reading the first arg
                    while (pass2.hasNext() && !pass2.hasNext("\\s+")
                            && !pass2.hasNext("\\,"))
                        arg1 = arg1 + pass2.next();

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();

                    //skipping ,
                    if (pass2.hasNext(","))
                        pass2.next();

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();

                    String arg2 = "";

                    //reading the first arg
                    while (pass2.hasNext() && !pass2.hasNext("\\s+")
                            && !pass2.hasNext("\\)"))
                        arg2 = arg2 + pass2.next();

                    //skipping whitespace
                    while (pass2.hasNext("\\s+"))
                        pass2.next();

                    //skipping closing )
                    if (pass2.hasNext("\\)"))
                        pass2.next();

                    //printing opcodes and operands
                    execute.println(locationCt + ": " + opCode4 + " " +
                        arg1 + " " + arg2);

                    locationCt+=3;
                    break;
                case "return":
                    done = true;
                    break;
                default:
                    error = true;
            }
        }

        if(error) {
            System.out.println("Unable to complete pass 2.");
            System.exit(0);
        }

        execute.close();
    }
}
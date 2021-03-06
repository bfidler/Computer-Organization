comment('

  Brayden Fidler (bfidler)
  CPSC 2310 Section 1
  Assignment 1
  Jan 30, 2018

  Description: This program uses a simple algortihm to calculate the greatest
  common divisor. It keeps the last divisor stored and prints it when the
  remainder of the Euclids algortihm yields 0.

')

word(a,100)
word(b,60)
word(r, 0)
word(q, 0)
word(temp, 0)

label(start)

  comment('Performing Euclids algortihm for greatestcommondivisor //
    start of loop')
  label(loop)

    comment('Branching if b == 0')
    load(b)
    beq0(done)

    comment('calculating quotient')
    load(a)
    div(b)
    store(q)

    comment('calculating r by storing a tempory term and subtracting it
      from a in')
    load(b)
    mul(q)
    store(temp)
    load(a)
    sub(temp)
    store(r)

    comment('Storing a as b -- a will hold the final divisor if r is 0')
    load(b)
    store(a)

    comment('Storing b as r -- b will break the loop if the remainder is 0')
    load(r)
    store(b)

    ba(loop)

  comment('End of program, printing the divisor')
  label(done)
    print(a)
    halt

end(start)

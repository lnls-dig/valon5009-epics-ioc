#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <dbDefs.h>
#include <registryFunction.h>
#include <subRecord.h>
#include <aSubRecord.h>
#include <epicsExport.h>
#include "epicsTypes.h"

/*
  subroutine: setOutput

  Overall:

  Calculate power level, attenuator and output buffer
  settings based on a given output power set point,
  and information about the power level steps,
  attenuator min and max step, and buffer gain.

  Description:

  The function sets the power level to the lowest value
  greater than the output power set point specified.
  Then, the attenuator is set so that the output power
  is as close as possible to the set point, but never
  greater than it.
  If the set point is too low, and cannot be reached
  using the attenuator, the buffer amplifier is
  disabled, and the power level and attenuator settings
  are obtained as described before.

  The subRecord fields are used as follows:

  Input:

  A: the output power set point in dB.
  B: the value in dB corresponding to the power level step 0.
  C: the value in dB corresponding to the power level step 1.
  D: the value in dB corresponding to the power level step 2.
  E: the value in dB corresponding to the power level step 3.
  F: the value in dB of each attenuator step.
  G: the buffer amplifier gain.
  H: the maximum attenuator value accepted.

  Output:

  I: power level setting.
  J: attenuator setting.
  K: buffer amplifier enable/disable (1/0).
  VAL: actual output power obtained.

  Constraints:

  Attenuator step (input F) must be non-zero and positive.
  Power level steps 0, 1, 2, and 3 must have increasing power in that order.
  Buffer amplifier gain (input G) must be positive.
  The maximum attenuator value (input H) must be positive.
*/
static long setOutput(subRecord *precord)
{

    epicsFloat64 diff = 0;
    epicsFloat64 ampGainDiff = 0;

    // check for errors
    if (precord->b > precord->c || precord->c > precord->d || precord->d > precord->e /* pwr levels are unordered */
        || precord->f <= 0     /* attenuator step is 0 or negative */
          || precord->g < 0    /* buffer amplifier gain is negative */
            || precord->h < 0) /* maximum att value is negative */
              return -1;

    // enable/disable buffer amplifier
    if (precord->a < precord->b - precord->h){
        precord->k = 0;
        ampGainDiff = precord->g; // gain will be subtracted from output
    }
    else {
         precord->k = 1;
    }

    // set level
    if (precord->a > precord->d - ampGainDiff) {             /* pwr level 3 */
        precord->i = 3; 
        diff = precord->e - ampGainDiff - precord->a;
        if (diff < 0) diff = 0; /* set point is unreachable:
                                   too low for attenuators and
                                   too high for output level options
                                   with buffer disabled */
        precord->val = precord->e;
    }
    else if (precord->a > precord->c - ampGainDiff) {        /* pwr level 2 */
        precord->i = 2;
        diff = precord->d - ampGainDiff - precord->a;
        precord->val = precord->d;
    }
    else if (precord->a > precord->b - ampGainDiff) {        /* pwr level 1 */
        precord->i = 1;
        diff = precord->c - ampGainDiff - precord->a;
        precord->val = precord->c;
    }
    else {                                               /* pwr level 0 */
        precord->i = 0;
        diff = precord->b - ampGainDiff - precord->a;
        precord->val = precord->b;
    }

    // set attenuator
    precord->j = ceil(diff / precord->f) * precord->f;

    // subtract att and amp gain diff from VAL
    precord->val -= precord->j + ampGainDiff;

    return 0;
}

/* Register these symbols for use by IOC code: */

epicsRegisterFunction(setOutput);

### Pre-processing and Drawing Selection

The raw csv files come in a format where they describe a given drawing trace with a timeseries of points. More specifically, each row has an x,y,z and a millis column. In that sense, with this notebook some functions are applied to the timeseries that:

1. Reset the co-ordinates, so that the start of the axis (0,0,0) is the bottom left corner of the interaction box on the side of the Kinect physical device.
2. Chop of the front and back tails of the drawing trace (to clear the different response times of each participant to the signal).
3. Remove duplicate points in the trace.
4. Interpolate some crazy values in the trace (to be able to use more drawings).

As far as the selection of drawings goes, there were two main reasons for why a manual vetting process was needed. First, there was no algotithm to check that a given drawing was indeed a lock, and second the algorithm that was used to create features was not guaranteed to work.

#### How the notebook is used

The notebook is used to visualize each drawing and ask for user input for whether a given lock qualifies. Then the vetted locks are saved anew, with their x,y,zs recalculated, front and back tails trimmed, some duplicate values removed, and sometimes some offshoot values interpolated.

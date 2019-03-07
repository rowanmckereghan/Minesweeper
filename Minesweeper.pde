import de.bezier.guido.*;
public final static int NUM_ROWS = 20, NUM_COLS = 20, NUM_BOMBS = 60;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>();
private ArrayList <MSButton> bombs2 = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean isLost = false;
private boolean isWon = false;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i = 0; i < buttons.length; i++)
        for (int z = 0; z < buttons[i].length; z++)
            buttons[i][z] = new MSButton(i, z);
    
    for (int k = 0; k < NUM_BOMBS; k++)
        setBombs();
}
public void setBombs()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[row][col]))
        bombs.add(buttons[row][col]);
}

public void draw ()
{
    background( 0 );
    if(isWon == true)
        displayWinningMessage();
}
public void displayLosingMessage()
{
    String loser = "Too bad.  Try Again?";
    for(int i = 0; i < loser.length(); i++)
    {
        buttons[9][i].clicked = true;
        buttons[9][i].setLabel(loser.substring(i,i+1));
    }
    isLost = true;
    //bombs2.add(buttons[this.r][this.c]);
    bombs = new ArrayList <MSButton>();


}
public void displayWinningMessage()
{
    String winner = "You Are The Champion";
    for(int i = 0; i < winner.length(); i++)
    {
        buttons[9][i].clicked = true;
        buttons[9][i].setLabel(winner.substring(i,i+1));
    }
    //bombs2.add(buttons[this.r][this.c]);
    bombs = new ArrayList <MSButton>();
}

public class MSButton
{
    private int r, c, markSum;
    private float x,y, width, height;
    private boolean clicked, marked, realClick, allClicked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = realClick = allClicked = false;
        markSum = 0;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager (Karen?)
    
    public void mousePressed() 
    {
        if (isLost == false && isWon == false)
        {
        clicked = true;
        if (mouseButton == RIGHT) 
         {
            if (realClick == true)
            {

            }
            else
            {
            marked = !marked;
            if (marked == false)
            {
                clicked = false;
                this.setLabel("");
            }
            for (int k = 0; k < buttons.length; k++)
                for(int m = 0; m < buttons[k].length; m++)
                    if(bombs.contains(buttons[k][m]) && buttons[k][m].isMarked())
                        markSum++;
            for (int x = 0; x < buttons.length; x++)
            {
                for(int y = 0; y < buttons[x].length; y++)
                {
                    if(!buttons[x][y].isClicked())
                    {
                        allClicked = false;
                        break;
                    }
                    else
                        allClicked = true;
                }
            }
            if(markSum == NUM_BOMBS && allClicked == true)
                isWon = true;
        }
        } 
        else if (bombs.contains(this))
            {
                bombs2.add(this);
                displayLosingMessage();
            }
        else if(countBombs(r, c) > 0)
        {
            setLabel("" + countBombs(r, c));
            this.realClick = true;
        }
        else
            for(int i = r - 1; i <= r + 1; i++)
                for(int z = c - 1; z <= c + 1; z++)
                    if(isValid(i, z) && !buttons[i][z].isClicked())
                            buttons[i][z].mousePressed();

    }
}

    public void draw () 
    {    
        if (isMarked())
            fill(0);
        else if(isClicked() && bombs.contains(this) ) 
             fill(255,0,0);
        else if(bombs2.contains(this))
            fill(255,0,0);
        else if(isClicked())
            fill( 200 );
        else 
        {
            fill( 100 );
        }
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int row, int col)
    {
         for ( int r = 0; r < NUM_ROWS; r++ )
            for ( int c = 0; c < NUM_COLS; c++ )
                if ( row == r )
                    if ( col == c)
                        return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
    int sum = 0;
        for (int i = row - 1; i <= row + 1; i++)
         {
            for (int z = col - 1; z <= col + 1; z++)
            {
                if(row == i && col == z)
                    sum = sum;
                else if (isValid(i, z) == true && bombs.contains(buttons[i][z]))
                    sum++;
            }
        }
                return sum;
    } 
}




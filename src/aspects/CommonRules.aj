package aspects;

import chess.*;
import chess.agent.*;
import chess.piece.*;

public aspect CommonRules {
    pointcut onMove(Player player, Move move):
            (execution(public boolean HumanPlayer.move(Move))
          || execution(public boolean StupidAI.move(Move)))
          && this(player) && args(move);

    public class Point {
        int x, y;
        public Point(int x, int y) {
            this.x = x;
            this.y = y;
        }
        public boolean isOnBoard() {
            return (x >= 0 && x < 8 && y >= 0 && y < 8);
        }
        @Override
        public String toString() {
            return "(" + x + ", " + y + ")";
        }
    }

    boolean around(Player player, Move move): onMove(Player, Move) && this(player) && args(move) {
        Point p1 = new Point(move.xI, move.yI);
        Point p2 = new Point(move.xF, move.yF);

        // Check positions (on the board & different)

        if (!p1.isOnBoard() || !p2.isOnBoard()) {
            if (player.getColor() == Player.BLACK) System.out.println(
                    "Tried to out of the board position (range : a->h & 0->7)");
            return false;
        }
        if (p1.x == p2.x && p1.y == p2.y) {
            if (player.getColor() == Player.BLACK) System.out.println(
                    "Tried to use the same position twice");
            return false;
        }

        // Check pieces (first is owned by the player & not the second)

        Spot[][] grid = player.getPlayGround().getGrid();
        Piece piece1 = grid[p1.x][p1.y].getPiece();
        Piece piece2 = grid[p2.x][p2.y].getPiece();

        if (piece1 == null) {
            if (player.getColor() == Player.BLACK) System.out.println(
                    "Tried to move an empty slot");
            return false;
        }
        if (piece1.getPlayer() != player.getColor()) {
            if (player.getColor() == Player.BLACK) System.out.println(
                    "Tried to move an enemy piece");
            return false;
        }
        boolean onEnemy = piece2 != null && piece2.getPlayer() != player.getColor();
        if (piece2 != null && !onEnemy) {
            if (player.getColor() == Player.BLACK) System.out.println(
                    "Tried to move on an ally piece");
            return false;
        }

        // Check move (valid pattern, inversed for black player)

        Move checkedMove = move;
        if (player.getColor() == Player.BLACK) {
            // Invert Y axis pour white move (to remove player dependency)
            checkedMove = new Move(
                    move.xI, 7 - move.yI,
                    move.xF, 7 - move.yF);
        }
        if (!piece1.isValidMove(checkedMove, onEnemy)) {
            if (player.getColor() == Player.BLACK) System.out.println(
                    "Invalid move for this piece");
            return false;
        }

        // Check sight (if needed by the piece)

        if (piece1.needSight()) {
            int xInc = 0;
            int yInc = 0;

            if (p1.x < p2.x) xInc = 1;
            if (p1.x > p2.x) xInc = -1;
            if (p1.y < p2.y) yInc = 1;
            if (p1.y > p2.y) yInc = -1;

            int x = p1.x + xInc;
            int y = p1.y + yInc;
            while (x != p2.x || y != p2.y) {
                if (grid[x][y].isOccupied()) {
                    if (player.getColor() == Player.BLACK) System.out.println(
                            "The piece has no place do to this move");
                    return false;
                }
                x += xInc;
                y += yInc;
            }
        }

        System.out.println("move : " + p1 + " -> " + p2);
        return proceed(player, move);
    }


    // TODO : AI uses and prints Y-1 ('e2' gives 5.2, should be 5.1)
}

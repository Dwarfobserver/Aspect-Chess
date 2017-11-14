package aspects;

import chess.Game;
import chess.agent.*;
import chess.piece.Piece;

import java.io.PrintWriter;

public aspect CommonRules {

    private PrintWriter logger;

    pointcut onMove(Player player, Move move):
            (execution(public boolean HumanPlayer.move(Move))
          || execution(public boolean StupidAI.move(Move)))
          && this(player) && args(move);

    boolean around(Player player, Move move): onMove(Player, Move) && this(player) && args(move) {

        ValidationData data = new ValidationData();
        data.player = player;
        data.p1 = new Point(move.xI, move.yI);
        data.p2 = new Point(move.xF, move.yF);

        if (!data.checkPositions()) return false;

        data.grid = player.getPlayGround().getGrid();
        data.piece1 = data.grid[data.p1.x][data.p1.y].getPiece();
        data.piece2 = data.grid[data.p2.x][data.p2.y].getPiece();

        if (!data.checkPieces()) return false;

        if (!data.checkMove()) return false;

        if (!data.checkSight()) return false;

        logger.println("Player " + player.getColorName() + " move : " + move);

        boolean result = proceed(player, move);

        if (data.handlePromotion()) {
            Piece newPiece = data.grid[data.p2.x][data.p2.y].getPiece();
            String pieceName = newPiece.getClass().getSimpleName();
            logger.println("Player " + player.getColorName() + " promoted Pawn to " + pieceName);
        }
        logger.flush();
        return result;
    }

    void around(String[] args):
            execution(public static void Game.main(String[])) && args(args) {
        try {
            logger = new PrintWriter("move-logs.txt", "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
        }
        proceed(args);
    }
}

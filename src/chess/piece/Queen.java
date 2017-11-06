package chess.piece;

import chess.agent.Move;
import chess.agent.Player;

public class Queen extends Piece {

    public Queen(int player) {
	super(player);
    }

    @Override
    public String toString() {
	return ((this.player == Player.WHITE) ? "D" : "d");
    }

    @Override
    public boolean isMoveLegal(Move mv) {
	return false;
	    }
}
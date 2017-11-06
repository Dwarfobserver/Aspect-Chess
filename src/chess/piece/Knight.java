package chess.piece;

import chess.agent.Move;
import chess.agent.Player;

public class Knight extends Piece {

    public Knight(int player) {
	super(player);
    }

    @Override
    public String toString() {
	return ((this.player == Player.WHITE) ? "C" : "c");
    }

    @Override
    public boolean isMoveLegal(Move mv) {
	return false;
	    }
}
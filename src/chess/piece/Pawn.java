package chess.piece;

import chess.agent.Move;
import chess.agent.Player;

public class Pawn extends Piece {

    public Pawn(int player) {
	super(player);
    }

    @Override
    public String toString() {
	return ((this.player == Player.WHITE) ? "P" : "p");
    }

    @Override
    public boolean isMoveLegal(Move mv) {
	return false;
	    }

}

package chess.piece;

import chess.agent.Move;
import chess.agent.Player;

public class Bishop extends Piece {

    public Bishop(int player) {
	super(player);
    }

    public Bishop() {
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

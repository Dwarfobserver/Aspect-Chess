package aspects;

import chess.Spot;
import chess.agent.Move;
import chess.piece.*;

public aspect PieceRules {

    // The knight does not have to see his target
    public abstract boolean Piece.needSight();
    // "OnEnemy" is used by pawns because their move change when killing an enemy piece
    public abstract boolean Piece.isValidMove(Move move, boolean onEnemy);

    @Override
    public boolean Pawn.needSight() {
        return true;
    }
    @Override
    public boolean Pawn.isValidMove(Move move, boolean onEnemy) {
        if (onEnemy) {
            return (move.xI + 1 == move.xF ||
                    move.xI - 1 == move.xF) &&
                    move.yI + 1 == move.yF;
        }
        else {
            return  move.xI == move.xF &&
                    move.yI + 1 == move.yF;
        }
    }

    @Override
    public boolean Bishop.needSight() {
        return true;
    }
    @Override
    public boolean Bishop.isValidMove(Move move, boolean onEnemy) {
        return Math.abs(move.xI - move.xF) == Math.abs(move.yI - move.yF);
    }

    @Override
    public boolean King.needSight() {
        return true;
    }
    @Override
    public boolean King.isValidMove(Move move, boolean onEnemy) {
        return  Math.abs(move.xI - move.xF) <= 1 &&
                Math.abs(move.yI - move.yF) <= 1;
    }

    @Override
    public boolean Queen.needSight() {
        return true;
    }
    @Override
    public boolean Queen.isValidMove(Move move, boolean onEnemy) {
        return  (move.xI == move.xF || move.yI == move.yF) ||
                (Math.abs(move.xI - move.xF) == Math.abs(move.yI - move.yF));
    }

    @Override
    public boolean Knight.needSight() {
        return false;
    }
    @Override
    public boolean Knight.isValidMove(Move move, boolean onEnemy) {
        int xShift = Math.abs(move.xI - move.xF);
        int yShift = Math.abs(move.yI - move.yF);
        return  (xShift == 1 && yShift == 2) ||
                (xShift == 2 && yShift == 1);
    }

    @Override
    public boolean Rook.needSight() {
        return true;
    }
    @Override
    public boolean Rook.isValidMove(Move move, boolean onEnemy) {
        return  move.xI == move.xF ||
                move.yI == move.yF;
    }

}

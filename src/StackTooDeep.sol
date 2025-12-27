// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract StackTooDeep {
     struct ReserveData {
        //stores the reserve configuration
        ReserveConfigurationMap configuration;
        //the liquidity index. Expressed in ray
        uint128 liquidityIndex;
        //the current supply rate. Expressed in ray
        uint128 currentLiquidityRate;
        //variable borrow index. Expressed in ray
        uint128 variableBorrowIndex;
        //the current variable borrow rate. Expressed in ray
        uint128 currentVariableBorrowRate;
        /// @notice reused `__deprecatedStableBorrowRate` storage from pre 3.2
        // the current accumulate deficit in underlying tokens
        uint128 deficit;
        //timestamp of last update
        uint40 lastUpdateTimestamp;
        //the id of the reserve. Represents the position in the list of the active reserves
        uint16 id;
        //timestamp until when liquidations are not allowed on the reserve, if set to past liquidations will be allowed
        uint40 liquidationGracePeriodUntil;
        //aToken address
        address aTokenAddress;
        // DEPRECATED on v3.2.0
        address __deprecatedStableDebtTokenAddress;
        //variableDebtToken address
        address variableDebtTokenAddress;
        // DEPRECATED on v3.4.0, should use the `RESERVE_INTEREST_RATE_STRATEGY` variable from the Pool contract
        address __deprecatedInterestRateStrategyAddress;
        //the current treasury balance, scaled
        uint128 accruedToTreasury;
        // In aave 3.3.0 this storage slot contained the `unbacked`
        uint128 virtualUnderlyingBalance;
        //the outstanding debt borrowed against this asset in isolation mode
        uint128 isolationModeTotalDebt;
        //the amount of underlying accounted for by the protocol
        // DEPRECATED on v3.4.0. Moved into the same slot as accruedToTreasury for optimized storage access.
        uint128 __deprecatedVirtualUnderlyingBalance;
    }

    struct ReserveConfigurationMap {
        uint256 data;
    }


  ReserveData internal _reserveData;

    function getReserveData() external view returns (ReserveData memory) {
        return _reserveData;
    }

    function setReserveData(ReserveData calldata newReserveData) external {
        ReserveData storage data = _reserveData;
        
        // Use scoped blocks to limit variable lifetime and process fields in batches to avoid stack too deep
        // Batch 1: Process first 3 fields
        {
            data.configuration = newReserveData.configuration;
            data.liquidityIndex = newReserveData.liquidityIndex;
            data.currentLiquidityRate = newReserveData.currentLiquidityRate;
        }
        
        // Batch 2: Process next 3 fields
        {
            data.variableBorrowIndex = newReserveData.variableBorrowIndex;
            data.currentVariableBorrowRate = newReserveData.currentVariableBorrowRate;
            data.deficit = newReserveData.deficit;
        }
        
        // Batch 3: Process next 3 fields
        {
            data.lastUpdateTimestamp = newReserveData.lastUpdateTimestamp;
            data.id = newReserveData.id;
            data.liquidationGracePeriodUntil = newReserveData.liquidationGracePeriodUntil;
        }
        
        // Batch 4: Process next 3 fields
        {
            data.aTokenAddress = newReserveData.aTokenAddress;
            data.__deprecatedStableDebtTokenAddress = newReserveData.__deprecatedStableDebtTokenAddress;
            data.variableDebtTokenAddress = newReserveData.variableDebtTokenAddress;
        }
        
        // Batch 5: Process last 5 fields
        {
            data.__deprecatedInterestRateStrategyAddress = newReserveData.__deprecatedInterestRateStrategyAddress;
            data.accruedToTreasury = newReserveData.accruedToTreasury;
            data.virtualUnderlyingBalance = newReserveData.virtualUnderlyingBalance;
            data.isolationModeTotalDebt = newReserveData.isolationModeTotalDebt;
            data.__deprecatedVirtualUnderlyingBalance = newReserveData.__deprecatedVirtualUnderlyingBalance;
        }
    }
}

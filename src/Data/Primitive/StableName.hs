{-# language MagicHash #-}
{-# language UnboxedTuples #-}

{-| Primitive operations on 'StableName'. This differs from the module
    'System.Mem.StableName', in that it works in 'ST', 'IO', and an monad
    transformer stack built on top of either. It is recommended that users
    read the documentation of 'System.Mem.StableName' to learn more about
    the properties of 'StableName's.
-}

module Data.Primitive.StableName
  ( StableName(..)
  , makeStableName
  , eqStableName
  ) where

import GHC.Exts (StableName#, isTrue#, eqStableName#,makeStableName#,unsafeCoerce#)
import Control.Monad.Primitive

--- | An abstract name for an object. This supports tests for equality,
--    but not hashing.
data StableName s a = StableName (StableName# a)

instance Eq (StableName s a) where
  (==) = eqStableName
  {-# inline (==) #-}

-- | Make a 'StableName' for an arbitrary object. The object is not
--   evaluated.
makeStableName :: PrimMonad m => a -> m (StableName (PrimState m) a)
makeStableName a = primitive $ \s ->
  case makeStableName# a (unsafeCoerce# s) of
    (# s', sn #) -> (# unsafeCoerce# s', StableName sn #)
{-# inline makeStableName #-}

-- | Equality on 'StableName' that does not require that the types of
--   the arguments match.
eqStableName :: StableName s a -> StableName s b -> Bool
eqStableName (StableName sn1) (StableName sn2) = isTrue# (eqStableName# sn1 sn2)
{-# inline eqStableName #-}

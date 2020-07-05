module Platform.AesonUtil where
import Data.Aeson.TH
import Language.Haskell.TH.Syntax
import ClassyPrelude as CLSY

commonJSONDeriveMany :: [Name] -> Q [Dec]
commonJSONDeriveMany names =
  CLSY.concat <$> mapM commonJSONDerive names

commonJSONDerive :: Name -> Q [Dec]
commonJSONDerive name =
  let lowerCaseFirst (y:ys) = toLower [y] <> ys 
      lowerCaseFirst "" = ""
      structName = fromMaybe "" CLSY.. lastMay CLSY.. splitElem '.' CLSY.. show $ name
  in deriveJSON defaultOptions{fieldLabelModifier = lowerCaseFirst CLSY.. CLSY.drop (CLSY.length structName)} name

import '@fontsource/roboto/300.css';
import '@fontsource/roboto/400.css';
import '@fontsource/roboto/500.css';
import '@fontsource/roboto/700.css';
import ReactOnRails from 'react-on-rails';

import Races from '../bundles/Races/components/Races';

// This is how react_on_rails can see the Races in the browser.
ReactOnRails.register({
  Races,
});

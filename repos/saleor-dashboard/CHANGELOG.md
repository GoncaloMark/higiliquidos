# Changelog

## 3.20.34

### Patch Changes

- 4fbd1ad: Replace an Apps section with a new Extensions section visible under a feature flag
  New Extensions section is split into two pages:

  1. Main Extensions page which presents a list of all installed apps
  2. Explore page which presents a list of available apps to install

  Currently, Extensions show only apps but in the future Extensions section will gather also plugins and webhooks (custom apps).

- 6875a88: Variant's empty attributes are no longer displayed in fulfillment creation form.
- 36a9943: Updated @saleor/app-sdk to 1.0.0
- 45c3f6c: The order list and details view now support the overcharged status. This means that you can now see pill with overcharged label when order has charge status overcharged
- 4d53e56: Menu item group now support on click handlers
- 9122a03: Knip no longer raises an error regarding "import.meta" in vite.config.js
- 62383cc: In quick search you can now search for product variants with SKU. This means product variants are a new item added to the search catalogue. Catalogue items now show their media, if available. Category item display message if they don't have parents.
- d7adfec: You can now see the correct quantity for unfulfilled lines in Order details page.
- 4df5005: Test results from the release workflow are now generated in the CTRF scheme and pushed to the qa-helpers repository.

## 3.20.33

### Patch Changes

- 779d410: Webhooks in app details section now are sorted based on which attempt is latest
- b007a2a: Login page now doesn't reload after submitting the login form. This means that email and password input remain filled after unsuccessful login attempt.

## 3.20.32

### Patch Changes

- 91b41a1: Now, the header near the input for note, when creating customer has correct text.
- edf04af: You can now close the channel availability modal in product variant edit form using "x" button
- 29a50ef: Last delivery attempt date is now the date of the newest attempt in given event delivery.
- 3dd70bb: Now the project uses the latest version of the Vitejs
- 594244a: You can now see extensions section in sidebar when feature flag is on
- f925a68: Order details now show correct quantity of items after some items have been returned.

## 3.20.31

### Patch Changes

- 5277d8f: You can now middle click on the links in order history event messages.
- d3bfbc2: Dashboard now properly handles failed or pending deliveries without any attempts in App alerts.
- 1405ff0: Chosen warehouses no longer persist between select dialogs.
- 03551ee: Node 20 can be now used along with Node 18, which will be removed in next release.
- e935b96: Fixed scaling issues for small images in OrderLine metadata dialog - now small images will scale to fit entire reserved space, just like other places in Salero Dashboard. Previously such images remained at their default size in px.
- 9070a79: Flaky orders tests using auto-retrying assertions on checking fulfillment status

## 3.20.30

### Patch Changes

- 4a56859: Collection table no longer shrinks its rows
- 75c203f: Checkbox and datapiker are now clickable in channel availlablity

## 3.20.29

### Patch Changes

- 4bcebbf: Reorder warehouses on channel edit is now called only when warehouses have been changed
- 37fdf66: The alert in the Apps link in the Dashboard's sidebar now hide after user is informed about apps' issues. This means the dot will hide after you enter the App list and will show only when there is a new failed webhook after your last visit.
- fe0b3e6: Now clicking in radio and checkbox in a channel availability section no more case error
- eb9d8ce: Clicking on "Apps" when there is an alert is now persisted after webhooks pending query is executed. This means that after viewing apps list the alert now correctly disappears after long time of inactivity when there has been no new alerts.
- 41834a8: Notifications will be now clearly visible and not be overlayed anymore by modals. Previously they were partially hidden by the modal's dropover.
- a2af73f: App list now shows an alert if app's webhooks have failed or the app is disabled. This means you can see if there are issues with your apps without having to enter app details.
- 1b0d02d: Now tests results in ctrf scheme are attached to job from manual trigger tests.
- eafaf9e: You can now save, update, and delete filter presets on a page types list
- 988f25a: Shipping details show fresh data after update
- a517466: Gift card details page now show correct balance amount after update
- 3ee3970: Menu item create dialog no more show static amount of item, now data is loading dynamically when user scrolls the list
- e6401c6: You can now see event delivery ID in webhook details section of an app.
- ebfc19a: Added `OrderLine` metadata editor when opening metadata modal for products on Order details page.
  It now allows editing `OrderLine`'s `metadata` and `privateMetadata` and viewing (read-only) `metadata` and `privateMetadata` for `OrderLine.variant`
- bc83281: "Apps" link in sidebar now shows an alert if one or more apps have failed or pending webhook deliveries. This means you can see if there are issues with your apps without having to enter app details.
- 2938372: Adding changesets can be now skipped on Pull Requests by adding `skip changeset` label
- 1b5c8d1: You can now see an alert with a correct date when a webhook has failed event delivery with attempts.
- a53950a: App alerts now save correct dates of failed attempts and clicks to user's metadata.
- 435a7b1: `@radix-ui/react-portal` and `@radix-ui/react-radio-group` were added as explicit dependencies, previously these packages were assumed to be installed from `@saleor/macaw-ui`
- 8a2842a: Legacy alert on gift cards list have been replaced by link to documentaion in page header
- f33c9a7: Webhooks with failed or pending event deliveries now appear on top in App's settings. App alert tooltip now takes less space on the screen.
- fdcd7c5: Now results from test report are pushed to qa repo
- 4162987: App delivery events are now fetched at a 5 minute interval. This means this heavy query is now used sparingly.
- f7a936b: Voucher details form now properly validate data when discount type is shipping
- 32b03f4: You can now see apps alerts when multiple apps have failed event deliveries.
- 5526cd5: Nginx config now server index.html to paths that doesnot contains dashboard
- e6ef0fb: Fixed issue in OrderLine metadata form dialog: when closing dialog, form state was preserved even when opened for different OrderLine.
  Now form state will be cleared properly on dialog closure.
- 2275ad9: "App alers" feature is now available in feature flags and is enabled by default.

## 3.20.28

### Patch Changes

- 2ab3653: Product types list page uses now new filters. New filters are under feature flag and are enabled by default.
- 6ece8a5: Test reports no longer mention users due to test tags matching GitHub usernames. Replace overlooked tag
- 3fdd2b2: Staff members list page use now new filters. New filters are under feature flag and are enabled by default.
- a04abc7: You can now save, update, and delete filter presets on a product types list
- eb76fa3: Publish only the table with the summary on PRs, now includes a quick link to the job summary. Added ISO formatted date to the report for future flakiness measurement.
- 402c88d: Modify menu tests to ensure the first item in the list is visible before proceeding.
- 9078b4b: Gather all single feature flags for filters into one
- 3b92997: Collection list filters have been ported to expression filtering. This means you can now use new filters in the Collection list.
- 5640a9d: Test reports no longer mention users due to test tags matching GitHub usernames.
- 5434419: You can now save, update and delete filter presets on the warehouse list page
- b7bc6a9: Now, non-code related files are not included in codecov report.
- 2d7fde8: Now tests results in ctrf scheme are attached to job and results are published in job summary and PR.
- 50d6564: Now, the files for collecting coverage was explicitly set, this means we will include also files that are not covered.
- 428bad7: Now the test coverage is being raported and tracked
- f3e75bc: List of customers now uses conditional filters
- 3862c59: Gift cards list page use now new filters. New filters are under feature flag and are enabled by default.
- 24c613d: List of draft orders now use new filters
- ceb1919: List of vouchers now use new filters
- 3232550: Apply improvments for new filters so they looks align
- 053be92: List of pages now uses conditional filters
- 659a7c2: Attributes list page use now new filters. New filters are under feature flag and are enabled by default.
- edf962c: Tests reports from artifacts will be protected by password

## 3.20.27

### Patch Changes

- a4041bb: Now product links on the collection points to the correct url.

## 3.20.26

### Patch Changes

- f0870c5: Opening item in new tab using cmd key on datagrid now takes into account mounting point
- 87b8124: Now you can re-order products within the collection.
- 19bdcd4: Order transaction list now displays the name of a transaction
- e0f586e: Now you can see pageviews in the posthog.
- 1c3a125: You can now edit note in order details. Notes in order details now show id of note, id of related note and type of note "added" or "updated"
- 41dfb69: You can now open datagrid list item in new tab using cmd/ctrl button
- a3a1eca: After creating a new collection, you should see a list of assigned channels
- 79b8255: Modals in the Dashboard are now aligned, all have the same max height. Loading items on scroll works when the dialog is displayed in large screen.
- 08e3449: Dashboard now sends source header to API, when ENABLED_SERVICE_NAME_HEADER=true. Requires core >=3.20.68.
- 36bc1be: Activates list items on the welcome page no longer implies that they are clickable
- 52cf576: Editor.js no more cause error during saving
- 6a4f082: You can now navigate back from collection details to collection list

## 3.20.25

### Patch Changes

- c9df392: Order sidebar now uses buttons from new macaw
- 9737ff3: Collection details page uses now Buttons from new macaw
- 616ad52: You can now see buttons from macaw-ui-next in customer details view and gift card details view.
- cb5fd4f: Add tracking button on order details uses button from new macaw
- 1053db7: Users are now properly anonymously identified
- ba9d6f5: This Pr is separating sources in testmo for playwright and cypress tests, and adding results for runs on PR to testmo

## 3.20.24

### Patch Changes

- f986ca7: You can now see contextual links to documentation in product, webhooks, order, staff members lists and Graphql Playground panel.
- 3c9889b: Some sentry errors have been fixed.
- 4ea5566: Now CI workflows use updated action to upload and download artifacts
- b44516b: You can now use custom auth headers in graphiql dev mode panel.
- 5717954: Now there can only be one login request running at a time. This means using a password manager to log in no longer cause an error. If there are too many login requests Dashboard now shows a corresponding error message.
- e2ce3c4: Product data is now properly displayed in webhook dry run modal.
  Add warning alert in webhook dry run modal for webhooks that don't have a valid object ids.
- 65ae19b: Batch of sentry errors has been fixed
- 109565e: Added explicit max width to transaction event tooltip. Thanks to that longer message won't overflow.
- d939e6b: Added switch focus using tab button, that may delay saving before input is filled.
- 0be566e: Posthog no longer collect the events from the staging environments. This means we track the data only in production environments.
- d56c9a5: Prevent a call update channel after voucher create when no voucher id returns from response
- f1f9898: App buttons no longer clip with app contents
- d120bae: Removed waitFor and set expanded metadata section to avoid flakyness
- 081c5c0: Now category and subcategories show proper description
- ffaa00f: You can now close order manual transaction modal by clicking the close button
- 4b42974: Split select link option into 2 different ones to avoid flakyness in tests
- 184297b: Now it's possible to filter orders by its metadata.
- 35b508d: Warning banner in tax settings and delete app modal now display properly in dark mode
- 6a89f7a: Add GitHub Workflow to check licenses
- 752b988: Playwright tests raport is generated even test failed
- 85fd37c: Add explicit waits for draft order shipping carrier button interaction
- f0cd832: Run test by cron workflow has been removed
- 35a74fb: Now webhooks permission alert displays appropriately in dark mode
- 47d93f0: Increased the maximum display length for `plainText` attribute to 10,000 characters.
- 7b0c73b: Discounts no longer blocks the UI when the user has no permissions for managing channels.

## 3.20.23

### Patch Changes

- 3c4462a: App buttons no longer clip with app contents
- ea74e8a: Warning banner in tax settings and delete app modal now display properly in dark mode

## 3.20.22

### Patch Changes

- e964e95: You can now see contextual links to documentation in product, webhooks, order, staff members lists and Graphql Playground panel.
- fb56837: Now there can only be one login request running at a time. This means using a password manager to log in no longer cause an error. If there are too many login requests Dashboard now shows a corresponding error message.
- 20b10c7: Removed waitFor and set expanded metadata section to avoid flakyness
- 3299739: Run test by cron workflow has been removed
- 1b5b001: Now webhooks permission alert displays appropriately in dark mode

## 3.20.21

### Patch Changes

- 8d08677: Removing value from area input in address form no more cause error
- c48e50b: The app no longer changes the url when it is already been updated.
- 38d9a92: Selecting sale entries no longer fails when browsing the sales list
- 315676c: The double success banner no longer appears during app installation
- 3e89b07: Assign product dialog no more crash when product has no channels
- 36fb327: Prevent a call update channel after voucher create when no voucher id returns from response
- 917c0f8: Adding tranalstions to shipping methods no more cause error
- 5013483: Assigning product to collection no more cause error
- 749a09f: Update variant file attribute value no more cause error

## 3.20.20

### Patch Changes

- a40691f: Environments created via Saleor Cloud now identify and report to PostHog. This means Dashboard now sends telemetry data regarding home page onboarding steps and links.
- da3e53b: Removed unnecessary expect that was waiting for the success banner, as it was causing delays on CI. Instead, the test rely on other assertions to verify that changes have been applied
- 3f2ca21: Onboarding state is now stored in user metadata, that means that onboarding state is persisted between logins on different machines
- c40fdf7: Add environment variables to GitHub Workflow to control when to show onboarding for new users
- d677431: Now the list app page shows footer that allows the user to sumbmit a demanded app.
- 479ae66: Merged expectSuccessBannerMessage and expectSuccessBanner into a single method, removed the redundant method, and updated tests to use the new unified method.
- 24691c4: Rename newHome to wecomePage to allow seamlessly removing a feature flag
- 13f63c2: New home page layout is now reponsive, it means that layout adjusts to desktop, tablet and mobile devices
- 67687b3: User onboardng steps are now checking when user does required actions
- e947997: E2E tests are now updated for new home page meaing that they don't fail when new home page is enabled.
- 18a4eae: Activity section in home page now has uniform padding with header, stock and sales.
- f1e5f34: Enhanced success banner verification in basePage.ts by adding network idle state check and parallel assertions, while modernizing array operations in shipping methods tests using spread syntax instead of .concat()
- 0c2971b: Add integration test for new home sidebar
- fab4b4e: Refactored tests by replacing direct banner visibility checks with `expectSuccessBanner()`.
  Removed unnecessary `waitForNetworkIdleAfterAction` wrappers.
  Simplified test scope for `staffMembers` and removed explicit timeouts where appropriate.
- f9130c4: You can now see an onboarding component that guides the user through Saleor Dashboard features.
- 9cd4da2: You can now see new sidebar with analytics and activities
- 981a0bc: Removed waitForNetworkIdleAfterAction and replaced it with a direct navigation call.Added blur actions on metadataKeyInput and metadataValueInput to ensure input stability before saving in scope of SALEOR_128
- 6990b1e: New home page with onboarding is now enabled, old home page code has been removed
- d9600ab: Removed waitForNetworkIdleAfterAction and added direct element waits to ensure readiness before actions.
- e48622c: Test set now includes tests for welcome page onboarding component.
- 8bc92e3: You can now see information tiles regarding Saleor Docs, community, and technical help in the home page.
- 4d9d127: Adjust inline discount test for precise floating-point comparison with .toFixed(2)
- 7250d03: Padding under home page tiles is now increased to prevent clipping

## 3.20.19

### Patch Changes

- fd98d31: Selecting sale entries no longer fails when browsing the sales list
- 05a2be7: Variant creation no longer reports an error when API call fails, this means this scenario is now handled gracefully.
- bd125e8: List item links are no longer rendered outside of cursor. This means you can now copy the item's URL with mouse right click or use middle click to open page in new tab.
- 747030e: Enhanced success banner verification in basePage.ts by adding network idle state check and parallel assertions, while modernizing array operations in shipping methods tests using spread syntax instead of .concat()
- 73f4a95: Refactored tests by replacing direct banner visibility checks with `expectSuccessBanner()`.
  Removed unnecessary `waitForNetworkIdleAfterAction` wrappers.
  Simplified test scope for `staffMembers` and removed explicit timeouts where appropriate.
- e1c0868: The "Save" button in Change Password form now submits the form data to Saleor.
- f4466d9: Now, codeql action is no longer needed since we enabled code analysis via GH configuration with default settings.
- a28cd97: Prepare base layout for new home, hide new home page under feature flag
- 54e77d2: You can now select attribute value from dropdown in datagrid cell
- 82cd647: Adjust inline discount test for precise floating-point comparison with .toFixed(2)

## 3.20.18

### Patch Changes

- 9436450: Optimize test by reusing an existing order instead of creating a new one
- 3db9f24: Increase global single test timeout to avoid false neagtive test results
- abdd791: Refactor tests to replace `waitForDOMToFullyLoad` with `waitForLoaderToDisappear`, making the test shorter by waiting only for the loader to disappear instead of the entire DOM to load.
- 711c368: Upgrade lz-string library to version that supports MIT license

## 3.20.17

### Patch Changes

- 725ab22: `.env.template` no longer references Demo environment.
- 4feda35: Increase global single test timeout to avoid false neagtive test results
- 55988f0: Moving test cases for activation and deactivation staff members to other file and running it in serial mode to avoid login in two tests in the same time (it can cause error with code LOGIN_ATTEMPT_DELAYED)
- 048b0fb: Added support for the new channel setting: `checkoutSettings.automaticallyCompleteFullyPaidCheckouts`. Setting can be changed in channel configuration page.
- a230369: Link value input in Navigation no longer overrides input value with cached value.

## 3.20.16

### Patch Changes

- 8f225fa: Fixes a bug when the text truncating breaks on undefined attribute value.

## 3.20.15

### Patch Changes

- bfb6237: Mailpit service uses has been removed due to issues with checking email during E2E runs on PRs. This means the tests no longer check if export emails have been received.
- 5b50332: The value of attribute type `plainText` is now capped. This prevents the UI from freezing when the value is very large.
- 3948065: The tax app version no longer displayed in the tax select input because showing the initial installed app version caused confusing

## 3.20.14

### Patch Changes

- 12edac4: Now dependencies are installed properly in our pipelines, this means auth scripts are no longer stopping.
- d15aff5: Now, swatch presents the preview of the selected image.
- 80869fb: When deleting product type with products the "View products" link now navigates to product list with correctly applied product type filter
- b9c8291: Now cron-workflow that runs e2e tests takes proper urls to for preparing accounts action
- 6c85d52: Back buttons now navigate to the list with previously used filters and pagination applied.
- 89b9170: "changeset/cli" version is now bumped to the latest version
- 75751b0: Now the create category button is consistent with the other views
- 4ef03df: When navigating to order details from the order list, the back button will now return you to the previous page with the same filters and pagination applied.
- 4e0a555: Now accounts are decoded using an encryption key

## 3.20.13

### Patch Changes

- 04d16fc37: Add e2e for managing products on draft order. Add e2e for placing draft order for non-existing customer.
- 8ea94af11: Enable by default feature flag for discount rules. Remove feature flags for product and order expression filters, so that expression filter will always show. Cleanup dead code after remove feature flags.
- 1ff350a22: Assigning product to shipping method weight rate no more cause error
- be5d5e65e: Modals in the Dashboard have been aligned, so that all contains close button
- fc80e34ef: Knip was added to the codebase and workflow triggered on pull request. This means developers will now be informed about unused exports and files.

## 3.20.12

### Patch Changes

- 8db152e60: Clicking a select channel on a product list and then click close button clear filter state, so when you click again select button, only one channel filter will be selected
- 3f74d5cb2: You can now see app's webhooks' event delivery attempts in app settings. These include last 6 failed or pending deliveries with their details: payload, status and date.
- c330adeb7: You can now provide 0 variant price value during product creation
- 350194c3d: Removing not required dropdown attribue value no longer cause error

## 3.20.11

### Patch Changes

- 9fb5665f1: Test for readonly access to apps are more table, so that should not check anything before content load.
- 858439dd7: You can now see a new card in home page that can redirect you to Saleor solution engineers contact information if you need technical advice.
- e831f9b95: Selecting channel from product list does not trigger URL change, so that clicking "Select channel" button without selecting channel will not be saved in URL.
- cce3b2cba: Adds conditional logic to the Merge Playwright Reports workflow, ensuring that the merge and upload steps are only triggered when the pull request has the run pw-e2e label applied.
- a5b84712a: Implementing timeouts ensures the workflow automatically terminates jobs taking too long, improving resource utilization and avoiding potential workflow hangs.
- 7e1e6a10d: Some end-to-end Playwright tests now have extended timeouts for UI elements to load. This means that automation tests should fail less. Playwright retires value has been set to 0.
- bd54e6b54: Fix a group of errors caused by reading property of undefined

## 3.20.10

### Patch Changes

- 73387c130: History timeline sections now have a bolded, dark header without a line separating them from the events.
- e91e592f7: E2E tests are no longer executed on every commit, this means performing e2e tests happens only when you add a label "run pw-e2e"
- 660f6c119: Users with "MANAGE_STAFF" permission no longer get an error when entering order details. This means that to access `privateMetadata` in variant "MANAGE_PRODUCTS" permission is required.
- 55d5a5f44: Shipping destination alert when creating a new order now has a correct link to shipping settings.
- 3dc1c6d9b: Grid no longer crashes when removing row.

## 3.20.9

### Patch Changes

- 069e6cc2c: You can now make a refund with shipping costs or custom shipping amount. This means you can make a refund without selecting line items.

## 3.20.8

### Patch Changes

- 640d5f6f5: SALEOR_119 now has increased timeouts for app instalation. This means the test should fail less.
- 09cf2adaf: SALEOR_191 now waits for the refund page to fully load
- 0eb90df03: Menu item dialog now use components form new Macaw
- bef2cbde2: Docker images will be automatically tag with with both the full version and just the minor
- 331af3943: You can now see draft order alert messages when channel is inactive or has no products
- ba5d47e8e: Modals for adding discounts and confirming deletion now use new MacawUI styles
- 942bb01db: Now you can set proper attribute value when editting content page.
- 762463819: Dashboard now scrolls the product list page to the top when you click on "Select channel" so that you can see the filter window
- ece769a9a: The gift card modals now use new macaw-ui components.
- 330012e11: MacawUI in Dashboard is now the newest available version. Dashboard no longer shows an error while installing packages. Price in shipping method select component now aligns to the right.
- f1b06f8e8: Remove skip from installing app tests and update workflow to run it only on releases or manual
- c052612f6: Now manual tests and tests on release can run on multiple projects

## 3.20.7

### Patch Changes

- ce05ffba2: Order details page now displays the name of the applied voucher.
- f8e6049fe: Now staging environments have changed domain, that means "staging-cloud.saleor.io" is no longer referenced in our pipelines
- b428bcd9f: Legacy Dialog component is no longer used
- e5bfa1218: You can now navigate on dropdown list. Dropdown stays close on focus.
- bbba0d2dc: You can now see permission edit list use default list color instead of accent blue color.
- 642e9f7cb: Showing negative amount in order details has been aligned
- efbca2b00: Now, missing translations are properly added to the order details.
- 037c67cb2: The stock settings no longer show a message that you need to create a warehouse when warehouses are already configured.
- f879d525a: App install error page now uses macaw-ui-next styles meaning that MaterialUI is no longer used in this view.

## 3.20.6

### Patch Changes

- c8a6d86d0: Login, password reset and error pages now use new Macaw buttons, text and styles.
- 5e3cc3fa0: You can now see a message instead of a loading animation when there are no categories, collections, products or variants assigned in Discounts
- 48b4146a0: You can now add and remove tags for gift cards without any application crash
- edaf42b95: Gift card details page and customer details page no longer crash when you have only some required permissions. This means that you can now view gift card details page if you have only gift card permissions and customer details page if you have only customer permissions.
- e73034386: You can click save button on voucher creation page to trigger validation
- 6289fbde4: You can now delete draft voucher codes during creation of new voucher
- 061412866: You can now update quantity per checkout in site settings
- 9434aea16: Make MenuItems' container scrollable in navigation section

## 3.20.5

### Patch Changes

- 0b9296f1c: You can now replace all environment variables instead of only API_URL in Docker and nginx
- d29c3f89d: Tests for shipping methods now wait to content load to start test
- fd29d47cb: Now developer can see the traces within Sentry
- f89484cc4: Plugin details view now displays channel list with proper padding and text with proper size.
- b464ee243: Now sentry sample rate sents only 10% of the traffic
- cfe015ab2: You can now see errors when required attributes are empty during product or page edition
- a1420b2c4: Page type page now displays section description in multiple lines.
- 8b345e605: Transaction capture modal no longer shows "Error" text when API error occurs. This means that the modal closes when mutation finishes so that result is visible.
- cf2eb131f: Now you can see initials in your account details when there is no avatar image set for your account.
- ef1c9cba5: Subscription query editor no longer shows incorrect required permissions for inserted query.
- 5098f2674: You can now assign more than 22 attribute for product and page type
- 508e53e6f: Category input in product page is no longer collapsed when empty

## 3.20.4

### Patch Changes

- 55d49ee01: You can now run all e2e tests without attributes.spec interference
- e094fa61e: The migrated dropdown components and there types no longer exist within the codebase
- e14df76d8: You can now run E2E tests locally with no issues
- 54b212460: Rich text editor errors related to 'holder' no longer are sent to Sentry.
- 4a593993c: You can run order e2e tests with updated test data
- e635bc153: You can now view channel and product details pages on tablets
- f29141acc: You can now search by order number in Navigator search.
- a711406f2: Components that show app token now display text in multiple lines instead of one.

## 3.20.3

### Patch Changes

- bd8fc8757: You can run e2e test for an order type discount in a draft order
- b39b04c50: Text in Dashboard now is aligned and is displayed correctly

## 3.20.2

### Patch Changes

- fd36e8e08: From now dashboard will be deployed to load test services in dev cloud
- 6f45d4435: Drop legacy Dialog and replace it with new macaw Dialog component in action dialogs,
  order change warehouse dialog, order payment dialog, add staff member dialog,
  staff user password restart dialog, tax select country dialog.
- 5b8262d72: Button for adding new refund now has a shorter label
- a565113e6: Fix custom ref checkout in dev deployment CI workflow
- 9f10e1bdb: Dashboard no longer uses Typography and Skeleton from Material. These components were replaced with MacawUI ones
- 088842b70: You can run E2E tests for inline discounts in draft orders
- a77ff9f9e: You can now see tax dropdown taking full width
- 15d5b8747: Saleor Dashboard no longer uses MUI Card component, it uses DashboardCard instead.
- 5a1025570: Add new service to dev deployment CI workflow

## 3.20.1

### Patch Changes

- 81d909bd1: You can now see macaw ui migration progress
- 125883658: Product variant forms now show missing price and name errors when these fields are empty.
- 55e72b855: Edit refund view no longer display title with typo when edit refund with line items
- 27a47265a: The legacy selects are no longer present within the codebase, this means you should use the ones from new macaw when developing the UI
- d4e284996: You can run e2e for updating order with non-manual refunds in status draft/failure

## 3.20.0

### Minor Changes

- 618bb01aa: E2E Fixing flaky navigation tests
- f9d1b2b7c: Adding CodeInspector plugin
- 8943ae241: Now you can see columns and their ordering that you previously selected when swtich betetween listing pages.
- 563b86557: Add tests for thirdparty apps
- 1fc4c348d: Swap new refund with with old one when feature flag toggle
- cb5988f38: E2E tests for customer CRUD
- 8856e2f03: You can now see Marketplace app list on automation deployment.
- 1dcb956f4: Adding e2e tests for promotion CRUD
- bdfb5e8e3: Now selected columns on the product list are being saved when browsing order details.
- 12622c182: Migrate dashboard to new font tokens
- 6c5be6662: Fix flaky test - TC: SALEOR_3 Create basic product with variant
- 5c30c8d46: Replace back icon with cloud one in sidebar return to cloud link, update copy to just Saleor Cloud
- 2111f9305: Now, the developer can access sidebar components on each page directly.
- e08dd6420: Introduces new refund flow for orders that allow users to refund items base on transactions. Grant refund and send refund is a single flow. User first has to create draft refund and then can transfer funds in one flow.
- bed0fa3b5: The list of transactions is now placed under the new section called "Transactions" when you visit order details page
- 93f5dcebf: You can now run e2e test for a manual refund type
- f1e716e86: Order Refund views no longer display duplicated errors or no errors at all when submitting the form.
- c14402c4a: You can now run E2E Playwright tests for staff members CRUD
- 687b1346e: You can now browse listing pages without additional reloadings
- e02050a43: This change adds a reusable GridTable component for ephemeral data edition.
- a9745e492: Remove brackets next to each order status title due to cause confusing for the clients
- 66f565d24: Adding tests for promotion rules CRUD
- ca23d8547: You can now create refund with lines even if all lines have been previously refunded.
- f7bb80cbe: The API_URI is no longer used across the codebase. API_URI stays in workflows for backward compatibility
- 0589970ef: Always show charge and authorized amount in payment section of order details
- d9bc7544e: Cypress tests are no longer possible to be executed
- 9c5e78652: This change disallows creating refund for orders created in transaction flow channels that have no transactions, as well as orders that have no refundable transactions
- 92ed22708: Allow to manually override number of shards to use during manual re-runs
- 68eb5cd62: Refund add dialog no longer allows proceeding to refund with lines view when all lines have been refunded and manual refund view when user doesn't have payment permissions.
- 9b87e78d4: You can now select created at column in product list
- 202b18fb5: Refactoring playwright setup file and moving auth specs
- 1c01b463a: Modal for refund reason now has an improved copy
- 4c919c106: Grid peersistance implementation
- 172bbe089: Adding prettier for code formatting
- be40ffd78: Fixing flaky tests - TC: SALEOR_32 and TC: SALEOR_33
- 4603cc532: Refund with lines view no longer allows creating/editing a refund with amount exceeding charged amount for selected transaction
- ceada3108: Changed trigger to workflow_dispatch and switched from issues to pr as a source of metrics
- d65766193: Warning message on manual refund view is no longer unreadable on dark mode
- b3a87cd5e: Implement refund add modal
- 1c8df0f59: Refund table now displays user initials on the avatar and full name on hover instead of an email.
- f25bf71fc: Adding e2e tests for permission groups
- 06678d0bd: Fixing flaky test - TC: SALEOR_106 Issue gift card with specific customer and expiry date
- e2e5c716c: Add playwright tests for edit and remove product types
- dbfe9b7f7: Rewritten tests for setting balance and exporting gift cards
- f84515021: E2E Test for adding promotion rules
- 08b55d409: Fixing flaky e2e tests
- d46265dfe: Introduce view for manual refund transaction
- b41583432: E2E Playwright tests: SALEOR_187, SALEOR_205, SALEOR_59, SALEOR_198, SALEOR_106 are no longer flaky
- 6597aaaef: Fixes incorrect button label for adding or editing refund reason
- ae560bf9d: Fixing assertions in flaky Playwright tests
- 1a3748728: Adding the new variant as a row is no longer possible from the product details. This means "add new variant" button now leads you to the variant creation page
- 04ca14958: For old verions tests with "old release" tag will be executing. Additionally adds more detailed title to results on slack and testmo"
- c0031af37: Amount input in refund form no longer displays incorrectly formatted prices after recalculation
- 1bfc3f5ab: Transaction refund related views no longer display confusing descriptions.
- c3ca12283: You can now toggle improved refund flow in features preview
- 3af5ac04c: Filters for orders now allow filtering by ID. This means its form handles one or multiple ID that you can attach by using comma, space, or enter for separation.
- ca83d3acb: Manual refund form no longer allows values greater than charged amount for selected transaction and now allows positive values lower than 1
- 88138bef4: Fixing another batch of flaky E2E tests
- d6c03b077: QA Adding back tests-nightly workflow
- 2c84b7aee: You can now open channel selection by clicking "Select channel" within any price cell on the product list. This means the dash "-" sign is no longer displayed there
- 5faad9ee3: Introduce menu items with sortcuts for GraphQL playground and search actions in sidebar.
  Move "Go to Saleor Cloud" button at bottom of sidebar
- bde2fe886: Changed e2e test case ids to remove duplicate case ids and fix inconsistencies between repo and Testmo. Thanks to this, our QA reports will be more accurate
- 31e4575df: add playwright test for translations
- d61fdb0b6: Add site settings e2e test
- 16b47e2bf: Fix duplicate validations on refund view
- 634265976: Show all transaction in manual refund view, disabled those that are not refundable
- a6ed4570f: Removing skips from e2e tests
- 2a091894f: This change replaces refund datagrid on order details view with GridTable for better clarity and UX.
- 024f2d012: # Optimizing playwright setup and playwright.config.ts files

  -Adding a conditioning to auth.setup.ts file to use existing auth json file if it's applicable
  -Added some optimizations to playwright config file
  -Cleaned up gh action for playwright tests (removed Cypress references)
  -Updating gh workflow for PR automation with extra test sharding
  -General cleanup of redundant code

- 488c8e409: Implement refunds datagrid on order details
- fb4d33a5c: Orders: In order list view you can now use new, easy to use and improved filters.
- 855a97419: You can now run E2E tests for refunds
- f95fcc447: Vertical lines are no longer visible for read-only grid tables
- 151f42b3d: E2E fixing flaky gift cards tests
- 2b0f7602f: Adding e2e navigation tests
- 7a7f0e447: Run tests from other repo
- bb16de58e: You can now see pending manual refunds on order details view.
- 70b2c40d0: Fixing still flaky test - TC: SALEOR_205 Bulk delete customers
- 434b169ab: Fixing flaky test - TC: SALEOR_205 Bulk delete customers
- 6a2c4a0a4: This change replaces the datagrid on refund create & edit views with GridTable component
- b048a5090: Introduce new icons for menu, remove not used icons
- 005713e8e: Now savebar is aligned with the rest of layout
- a47581e31: Adding e2e tests for attributes
- 99a9c2837: Fixing flaky e2e tests
- dd8d60a4e: Fixing flaky test: TC: SALEOR_87 Edit voucher Usage Limits: used in total, per customer, staff only, code used once
- 12d7b9021: Open release PR after automation tests for core releases passes
- fd8368fd4: Fixes button font weights
- ec21ae379: Add playwright tests for page types
- 7d7fd4e12: New github action gathering repo metrics
- 18492763f: Now you can see the updated appearance of the bottom bar that holds save and back actions. This means functionality has not be changed
- c956f3543: Fixing flaky E2E test for gift cards
- 251e206f3: Remove branch name warning from pre-push
- 7077d6a55: Use dummy app in delete app test
- 99d1c6f83: Fix typo in postTestsResults.js
- b8bd24297: Refund views have now more consistent UI

### Patch Changes

- 7ff18ac1e: Product edition no longer change the others work when changing different fields simultaneously. This means UI sends only form fields that were changed.
- dfb19e5e2: The legacy multiselect are not longer present within the codebase. this means you should use the ones from new macaw when developing the UI
- 9d8a21f51: Login via API in order to setup playwright tests is working in serial mode
- f53973f2d: Manual transaction modal has now improved design that matches other modals.
- 345eeb041: You can now run e2e tests without flakiness
- f99fc51cd: Fix building docker image after move service worker to assets dir
- a9c750a01: You can no longer see a duplicated cancel button when canceling the transaction. This means you now can go back to edition by using "back" button and "cancel" to continue your intention
- 31a73ea21: Fixes a bug where order and gift card details views show incorrect avatar in history component. Notes added by apps will now show app's name and avatar. All events will now use the same date format to improve consistency.
- 2952fe571: The selected value is no longer filtering the options when using any select list with autocomplete
- a246798df: Fix showing empty tooltip when no content by bumping macaw-ui to newest
- 7f729f2d2: Dashboard will now allow to set publication date and availability date with time. This change also replaces deprecated date fileds with datetime fields.
- 97c0c844d: Read-only metadata keys and values will now be displayed as regular inputs, making them easier to read and preventing them from looking disabled.
- ea3c28809: Transaction titles in order details now include its ordinal number and creation date. This means that all titles now follow the same format.
- 9226dc965: Fix showing empty price when value is zero
  Improve showing discount type in order payment details
- d0ef1f3d8: App and User avatars in order details now all have the same color.
- 1028d48d8: You can now open issue gift card modal without any flickering
- 4eaa036cc: Fix product list crash when description contains empty object
  Improve description by removing html tags and &nbsp;
- f6d44a902: Manipulating timeouts of Playwright tests
- ad3ad6d84: The boolean attribute has been changed from a toggle to a select. This change helps visualize when the attribute has not been set.
- 3231bb525: You can now properly edit permission groups when you have full access
- 528fef012: Product details view will not show product categories with its ancestors. It will make it easier to choose product's category.
- c10dd8a6a: Add clarity to order cancel dialog
- b475eb8b5: Add product analytics on cloud
- 0fb6777c4: History component's texts will now have unified colors
- 18cb0ec76: Adding tests for readonly access to Apps
- db8b2d9b9: Flow settings in channel creation will now persist after channel is created
- 56eb4d649: Searching for countries and other items is now more efficient, making it easier to find what you need. Additionally, the Dashboard Navigator UI has been improved to match the rest of the application, providing a more consistent experience.
- 232cd2a12: Previously we allowed user to select either flat rates or any tax app. To avoid problems if there are more tax apps installed this change adds ability to select tax app that will be used to calculated taxes per channel. User can also select tax app for country exception while configuring taxes. Related [RFC](https://github.com/saleor/saleor/issues/12942)
- e7e639b79: Addedd support for the BrokerProperties webhook header
- 9edf2eabc: Products in a list of products to be excluded from shipping will no longer be selectable if not available in chosen channels.
- e234ddc0f: Fix showing promotion discount type in order summary
- ddd28ecf1: Increase playwright maxFailures to 10 (how many allowed failures, if exceeding skip remaining tests)
- 290104119: Waits if editorjs is ready before it's destroyed. This change aims to lower number of alerts caused by editorjs
- c8f4b0ad3: Set codeowners based on new GH groups
- f82600a16: Fixes an issue that prevented users from pasting values smaller than 10 into datagrid cells
- d1430ea40: Avatars in transaction events no longer show broken image instead of initials.
- 4bd369b09: Now you can see the reason why shipping methods are incorrect when creating draft orders. This means creating new draft orders will pop up an error with the details of incorrect shipping.
- 217cb106d: The selected value is no longer filtering the options when using any select list in product variant table
- 69d2c6bec: This change replaces old service worker with a noop service worker. Saleor Dashboard will no longer actively use service worker for caching and registering fonts.
- 51a360f2a: Improve error color on datagrid
- dfedc1010: The action buttons in the transaction section of the order view are now unified with the other buttons in that view.
- dfe8e1d20: Fixes an issue where product export threw an error due to invalid input data
- 9edf2eabc: Show info and disable checkbox in AssignProductDialog when product does have channels overlap with selected channels
- 2830c9cfe: Fix release workflow
- 8e0e208fd9: Fix dockerfile build error caused by deleted file and bash script
- 80b8c785e: Show all gift card used in order details
- 756681f46: Show discount name for promotion discount type

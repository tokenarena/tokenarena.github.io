import Dashboard from "layouts/Dashboard/Dashboard.jsx";
import LandingPage from "layouts/Landingpage/LandingPage.jsx";

var indexRoutes = [
	{ path: "/", name: "Landing", component: LandingPage },
	{ path: "/dashboard", name: "Home", component: Dashboard }
	];

export default indexRoutes;
